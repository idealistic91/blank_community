class EventsController < ApplicationController
  before_action :get_community
  before_action :get_event, only: [:show, :edit, :update, :destroy, :join, :leave, :public_join, :send_poll]
  before_action :get_events, only: [:index, :fetch]
  before_action :get_membership
  before_action :load_bot, except: [:index, :show, :new]

  def index
    @upcoming = @events.include_game_members.upcoming_events
    @nav_items = [
        { key: :upcoming, partial: 'events/partials/upcoming', label: 'Bevorstehend'
        },
        { key: :past, label: 'Archiv'
        }
    ]
  end

  def show; end

  def new
    @event = Event.new
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
        # Save games
        save_games(@event, games_params['games_attributes'])
        # Todo: Have nested attributes for hosting events
        @event.add_host(@membership.id)
        format.html {
          send_notification(@membership.nickname, @event.event_embed)
          redirect_to community_event_path(@community, @event), notice: 'Event was successfully created.' 
        }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { 
          flash[:alert] = "Event konnte nicht gespeichert werden. #{@event.errors.full_messages.join(', ')}"
          render :new 
        }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @event.update(event_params)
        update_games(@event, games_params['games_attributes'])
        format.html { redirect_to community_event_path(@community, @event), notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html {
          flash[:alert] = "Event konnte nicht gespeichert werden. #{@event.errors.full_messages.join(', ')}"
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
        if @event.join(@membership)
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
    if @event.join(@membership)
      flash[:success] = 'Erfolgreich beigetreten'
    else
      flash[:alert] = @event.errors.full_messages.join(', ')
    end
    redirect_to community_event_path(@community, @event)
  end

  def leave
    respond_to do |format|
      format.js {
        if @event.hosts.include?(@membership)
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

  def send_poll
    respond_to do |format|
      format.js {
        #send_notification(@membership.nickname)
        render json: { success: "true", message: 'Poll was send to the others' }
      }
    end
  end

  def fetch
    @past = @events.past_events
    element = render_to_string partial: 'events/partials/past', layout: false, format: 'html'
    respond_to do |format|
      format.js {
        render json: {success: "true", result: element}
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
    render json: { success: true, list: list, button: button, flash_box: flash_html } and return
  end

  def event_params
    params[:event][:date].split('-').each_with_index {|el, i| params[:event]["start_at(#{i+1}i)"] = el }
    params[:event][:date].split('-').each_with_index {|el, i| params[:event]["ends_at(#{i+1}i)"] = el }
    params.require(:event).permit(:title, :start_at, :ends_at, :date, :description, :title_picture, :slots, games_attributes: [:igdb_id, :id, :name])
  end

  def games_params
    params.require(:games).permit(games_attributes: [:igdb_id, :name, :id, :destroy])
  end

  def get_community
    if params[:id] || params[:community_id]
      @community = Community.find_by(id: params[:community_id])
    else
      @community = @current_community
    end
    unless @community
      flash[:alert] = "Community not found!"
      redirect_back(fallback_location: root_path)
    end
  end

  def get_events
    @events = @community.events
  end

  def get_membership
    @membership = current_user.membership_by_community(@community.id).first
    unless @membership
      flash[:alert] = "You do not have a membership to this community!"
      redirect_back(fallback_location: root_path)
    end
  end

  def get_event
    @event = @community.events.where(id: params[:id]).first
    unless @event
      flash[:alert] = "Event not found!"
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

  def update_games(event, params)
    params.each do |key, game_params|
      if game_params['id']
        if game_params['destroy']
          event_game = EventGame.find_by(game_id: game_params['id'], event: event)
          event_game.destroy unless event_game.nil?
        else
          event.games << Game.find_by(id: game_params['id']) unless event.game_ids.include?(game_params['id'].to_i)
        end
      else
        game = Game.new(game_params)
        event.games << game
      end
    end
  end

  def save_games(event, params)
    params.each do |key, game_params|
      if game_params['id']
        event.games << Game.find_by(id: game_params['id']) unless event.game_ids.include?(game_params['id'].to_i)
      else
        game = Game.new(game_params)
        event.games << game
      end
    end
  end
end
