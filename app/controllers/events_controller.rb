class EventsController < ApplicationController

  include Discord

  before_action :set_event, only: [:show, :edit, :update, :destroy, :join]

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
    @event.hosting_events << HostingEvent.create(event_id: @event.id, member_id: current_user.member.id)
    respond_to do |format|
      if @event.save
        format.html { 
          inform_discord
          redirect_to @event, notice: 'Event was successfully created.' 
        }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
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
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def join
    respond_to do |format|
      format.js {
        @event.members << current_user.member
        template = render_to_string partial: 'events/participants_list', content_type: 'text/html', locals: { event: @event }
        join_notification
        render json: { template: template }
      }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:title, :start_at, :ends_at, :date, :description, :title_picture, :game_id)
    end

    def join_notification
      DISCORD_BOT.send_to_channel('chat', @event.join_notification(current_user.member.nickname))
    end

    def destroy_notification
      DISCORD_BOT.send_to_channel('chat', @event.cancel_notification(current_user.member.nickname))
    end

    def inform_discord
      DISCORD_BOT.send_to_channel('chat', @event.created_notification(current_user.member.nickname))
    end
end
