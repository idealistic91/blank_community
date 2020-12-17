class EventsController < ApplicationController
  before_action :get_community
  before_action :get_event, only: [:show, :edit, :update, :destroy, :join, :leave, :public_join]
  before_action :get_events, only: :index
  before_action :get_membership
  before_action :load_bot, except: [:index, :show, :new]

  def index
    @events = @events.including_game
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
      @event.members << @membership
      format.js {
        if @event.valid?
          flash.now[:success] = 'Erfolgreich beigetreten'
          render_join_leave
        else
          flash.now[:error] = @event.errors.full_messages.join(', ')
          render_flash_as_json
        end
      }
    end
  end

  def public_join
    @event.members << @membership
    if @event.valid?
      flash[:success] = 'Erfolgreich beigetreten'
    else
      flash[:error] = @event.errors.full_messages.join(', ')
    end
    redirect_to community_event_path(@community, @event)
  end

  def leave
    respond_to do |format|
      format.js {
        if hosts.map(&:member).include?(@membership)
          flash.now[:error] = 'Du bist Host dieses Events und kannst daher das Event nicht verlassen!'
          render_flash_as_json
        else
          @event.members.delete(@membership)
          flash.now[:success] = "Du hast <strong>#{@event.title}</strong> verlassen".html_safe
          render_join_leave
        end
      }
    end
  end

  private

  def render_join_leave
    list = render_to_string partial: 'events/participants_list', content_type: 'text/html', locals: { event: @event }
    button = render_to_string partial: 'events/partials/join_leave_button', content_type: 'text/html',
                              locals: { name: action_name == 'join' ? "Verlassen" : "Teilnehmen",
                                action: action_name == 'join' ? :leave : :join,
                                event: @event, style: action_name == 'join' ? :danger : :primary }
    send_notification(@membership.nickname)
    render json: { list: list, button: button, flash_box: flash_html } and return
  end

  def event_params
    params[:event][:date].split('-').each_with_index {|el, i| params[:event]["start_at(#{i+1}i)"] = el }
    params[:event][:date].split('-').each_with_index {|el, i| params[:event]["ends_at(#{i+1}i)"] = el }
    params.require(:event).permit(:title, :start_at, :ends_at, :date, :description, :title_picture, :game_id, :slots)
  end

  def get_community
    if params[:id]
      @community = Community.find_by(id: params[:community_id])
    else
      @community = @current_community
    end
    unless @community
      flash[:error] = "Community not found!"
      redirect_back(fallback_location: root_path)
    end
  end

  def get_events
    @events = @community.events
  end

  def get_membership
    @membership = current_user.membership_by_community(@community.id).first
    unless @membership
      flash[:error] = "You do not have a membership to this community!"
      redirect_back(fallback_location: root_path)
    end
  end

  def get_event
    @event = @community.events.where(id: params[:id]).first
    unless @event
      flash[:error] = "Event not found!"
      redirect_back(fallback_location: root_path)
    end
  end

  def load_bot
    @bot = Discord::Bot.new(id: @community.server_id)
  end

  def send_notification(nickname, embed = nil)
    Thread.new do
      channel = @community.get_main_channel
      @bot.send_to_channel(channel[:name], @event.send("#{action_name}_notification", nickname), embed) if channel
    end
  end
end
