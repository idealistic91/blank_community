class EventsController < ApplicationController

  include Discord
  
  before_action :get_community
  before_action :get_event, only: [:show, :edit, :update, :destroy, :join, :leave]
  before_action :get_events, only: :index
  before_action :get_membership
  before_action :load_bot, except: [:index, :show, :new]

  # GET /events
  # GET /events.json
  def index
    @events = Event.including_game
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
    @game = Game.new
  end

  # GET /events/1/edit
  def edit
    @game = @event.try(:game)
    @game ||= Game.new
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    @event.hosting_events << HostingEvent.create(event_id: @event.id, member_id: @membership.id)
    @event.community = @community
    respond_to do |format|
      if @event.save
        format.html { 
          inform_discord
          redirect_to community_event_path(@community, @event), notice: 'Event was successfully created.' 
        }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { 
          flash[:error] = "Event konnte nicht gespeichert werden. #{@event.errors.full_messages}"
          render :new 
        }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to community_event_path(@community, @event), notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { 
          debugger
          flash[:error] = "Event konnte nicht gespeichert werden. #{@event.errors.full_messages}"
          render :edit 
        }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    destroy_notification
    @event.destroy
    respond_to do |format|
      format.html { redirect_to community_events_path(@community), notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def join
    respond_to do |format|
      format.js {
        @event.members << @membership
        list = render_to_string partial: 'events/participants_list', content_type: 'text/html', locals: { event: @event }
        button = render_to_string partial: 'events/partials/join_leave_button', content_type: 'text/html',
                  locals: { name: 'Verlassen', action: :leave, event: @event, style: :danger } 
        join_notification
        render json: { list: list, button: button }
      }
    end
  end

  def leave
    respond_to do |format|
      format.js {
        @event.members.delete(@membership)
        list = render_to_string partial: 'events/participants_list', content_type: 'text/html', locals: { event: @event }
        button = render_to_string partial: 'events/partials/join_leave_button', content_type: 'text/html',
                  locals: { name: 'Teilnehmen', action: :join, event: @event, style: :primary } 
        leave_notification
        render json: { list: list, button: button }
      }
    end
  end

  private
    # Only allow a list of trusted parameters through.
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

    def join_notification
      # Todo: get membership instead of member
      @bot.send_to_channel('chat', @event.join_notification(@membership.nickname))
    end

    def leave_notification
      # Todo: get membership instead of member
      @bot.send_to_channel('chat', @event.leave_notification(@membership.nickname))
    end

    def destroy_notification
      # Todo: get membership instead of member
      @bot.send_to_channel('chat', @event.cancel_notification(@membership.nickname))
    end

    def inform_discord
      # Todo: get membership instead of member
      @bot.send_to_channel('chat', @event.created_notification(@membership.nickname), @event.event_embed)
    end
end
