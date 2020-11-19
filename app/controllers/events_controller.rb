class EventsController < ApplicationController
  before_action :get_community
  before_action :get_event, only: [:show, :edit, :update, :destroy, :join, :leave]
  before_action :get_events, only: :index
  before_action :get_membership
  before_action :load_bot, except: [:index, :show, :new]

  def index
    @events = Event.including_game
  end

  def show; end

  def new
    @event = Event.new
    @game = Game.new
  end

  # GET /events/1/edit
  def edit
    @game = @event.try(:game)
    @game ||= Game.new
  end

  def create
    @event = Event.new(event_params)
    @event.community = @community
    respond_to do |format|
      if @event.save
        # Todo: Have nested attributes for hosting events
        @event.add_host(@membership.id)
        @event.host_join_event
        format.html {
          send_notification(@membership.nickname, @event.event_embed)
          redirect_to community_event_path(@community, @event), notice: 'Event was successfully created.' 
        }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { 
          flash[:error] = "Event konnte nicht gespeichert werden. #{@event.errors.full_messages.join(', ')}"
          render :new 
        }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to community_event_path(@community, @event), notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html {
          flash[:error] = "Event konnte nicht gespeichert werden. #{@event.errors.full_messages.join(', ')}"
          render :edit 
        }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @event.destroy
    send_notification(@membership.nickname)
    respond_to do |format|
      format.html { redirect_to community_events_path(@community), notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  # Todo: Make join/leave one action
  def join
    respond_to do |format|
      format.js {
        @event.members << @membership
        render_join_leave
      }
    end
  end

  def leave
    respond_to do |format|
      format.js {
        @event.members.delete(@membership)
        render_join_leave
      }
    end
  end

  private

  def render_join_leave
    list = render_to_string partial: 'events/participants_list', content_type: 'text/html', locals: { event: @event }
    button = render_to_string partial: 'events/partials/join_leave_button', content_type: 'text/html',
                              locals: { name: action_name == 'join' ? "Verlassen" : "Teilnehmen", action: action_name == 'join' ? :leave : :join, event: @event, style: action_name == 'join' ? :danger : :primary }
    send_notification(@membership.nickname)
    render json: { list: list, button: button }
  end

  def event_params
    params[:event][:date].split('-').each_with_index {|el, i| params[:event]["start_at(#{i+1}i)"] = el }
    params[:event][:date].split('-').each_with_index {|el, i| params[:event]["ends_at(#{i+1}i)"] = el }
    params.require(:event).permit(:title, :start_at, :ends_at, :date, :description, :title_picture, :game_id, :slots)
  end

  def get_community
    @community = Community.find_by(id: params[:community_id])
  end

  def get_events
    @events = @community.events
  end

  def get_membership
    @membership = current_user.membership_by_community(@community.id).first
  end

  def get_event
    @event = @community.events.where(id: params[:id]).first
  end

  def load_bot
    @bot = Discord::Bot.new(id: @community.server_id)
  end

  def send_notification(nickname, embed = nil)
    Thread.new do
      @bot.send_to_channel('chat', @event.send("#{action_name}_notification", nickname), embed)
    end
  end
end
