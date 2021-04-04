class EventsController < ApplicationController
  before_action :get_community
  before_action :get_event, only: [:show, :edit, :update, :destroy, :join, :leave, :public_join, :send_poll, :join_team, :update_team, :assign_captain]
  before_action :get_events, only: [:index, :fetch]
  before_action :get_membership
  before_action :load_bot, except: [:index, :show, :new, :update_team]
  before_action :get_participant, only: [:show, :join_team, :join, :leave, :update_team, :assign_captain]

  def index
    @scope = params[:scope] if scope_set_and_valid?
    @scope ||= :live
    @result = @events.include_game_members.send("#{@scope}_events")
    @nav_items = [
        { key: :live, partial: nil, label: 'Live', locals: { events: nil } },
        { key: :upcoming, partial: nil, label: 'Bevorstehend', locals: { events: nil } },
        { key: :past, partial: nil, label: 'Archiv', locals: { events: nil } }
    ]
    active_item_index = @nav_items.index{ |item| item[:key] == @scope.to_sym }
    @nav_items[active_item_index][:locals][:events] = @result
    @nav_items[active_item_index][:partial] = 'events/partials/list'
    @nav_items[active_item_index][:active] = true
  end

  def show; end

  def new
    @event = Event.new
    @event.build_event_settings
  end

  def edit
    @event.build_event_settings if @event.event_settings.nil?
  end

  def create
    @event = Event.new(event_params)
    @event.community = @community
    respond_to do |format|
      if @event.save
        # Save games
        if params[:games]
          save_games(@event, games_params['games_attributes'])
        end
        # Todo: Have nested attributes for hosting events
        format.html {
          send_notification(@membership.nickname, @event.event_embed)
          redirect_to community_event_path(@community, @event), notice: 'Event was successfully created.' 
        }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { 
          flash[:alert] = "Event konnte nicht gespeichert werden. #{@event.errors.full_messages.join(', ')}"
          @games = find_or_create_games(games_params['games_attributes'])
          render :new 
        }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @event.update(event_params)
        update_games(@event, games_params['games_attributes']) if params[:games]
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
          get_participant
          flash.now[:success] = 'Erfolgreich beigetreten'
          render_join_leave
        else
          flash.now[:alert] = @event.errors.full_messages.join(', ')
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
          flash.now[:alert] = 'Du bist Host dieses Events und kannst daher das Event nicht verlassen!'
          render_flash_as_json
        else
          flash_msg = @event.leave(@membership) ? "Du hast <strong>#{@event.title}</strong> verlassen".html_safe : @event.errors.full_messages.join(', ')
          flash.now[@event.errors.any? ? :alert : :success] = flash_msg
          get_participant
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
    scope = params[:scope]
    return unless allowed_fetch_params.include?(scope)
    @fetched_events = @events.include_game_members.send("#{scope}_events")
    element = render_to_string partial: 'events/partials/list', locals: {events: @fetched_events }, layout: false
    respond_to do |format|
      format.js {
        render json: {success: true, result: element}
      }
    end
  end

  def join_team
    @team = Team.find_by(id: params[:team_id])
    if @participant && @team
      @participant.update_attribute(:team_id, @team.id)
      @event.teams.where(captain_id: @participant.id).each do |team|
        team.unassign_captain
      end
      @event.reload
      team_list = render_to_string partial: 'events/team_list', locals: { event: @event, participant: @participant }, layout: false
      render json: { success: true, list: team_list } and return
    else
      render json: { success: false, message: 'Team oder Teilnehmer nicht gefunden' } and return
    end
  end

  def update_team
    @team = Team.find_by(id: params[:team_id])
    if @team.update(team_params)
      team_list = render_to_string partial: 'events/team_list', locals: { event: @event, participant: @participant }, layout: false
      render json: { success: true, list: team_list } and return
    else
      render json: { success: false, message: "Nope" } and return
    end
  end

  def assign_captain
    @team = Team.find_by(id: params[:team_id])
    if @team.captain == @participant
      @team.captain = nil
      @team.save
    else
      @team.assign_captain(@participant)
    end
    team_list = render_to_string partial: 'events/team_list', locals: { event: @event, participant: @participant }, layout: false
    render json: { success: true, list: team_list } and return
  end

  private

  def render_join_leave
    if @event.is_versus? && @participant
      list = render_to_string partial: 'events/team_list', content_type: 'text/html', locals: { event: @event, participant: @participant }
    else
      list = render_to_string partial: 'events/participants_list', content_type: 'text/html', locals: { event: @event }
    end
    button = render_to_string partial: 'events/partials/join_leave_button', content_type: 'text/html',
                              locals: { name: action_name == 'join' ? "Verlassen" : "Teilnehmen",
                                action: action_name == 'join' ? :leave : :join,
                                event: @event, style: action_name == 'join' ? :danger : :primary }
    send_notification(@membership.nickname)
    render json: { success: true, list: list, button: button, flash_box: flash_html } and return
  end

  def event_params
    if params[:event][:date].blank?
      [4, 5].each do |n|
        params[:event].delete("start_at(#{n}i)")
        params[:event].delete("ends_at(#{n}i)")
      end
    else
      # adds date to start_at & ends_at params
      params[:event][:date].split('-').each_with_index {|el, i| params[:event]["start_at(#{i+1}i)"] = el }
      params[:event][:date].split('-').each_with_index {|el, i| params[:event]["ends_at(#{i+1}i)"] = el }
    end
    params.require(:event).permit(:created_by, :title, :start_at, :ends_at, :date, :description, :title_picture, :slots,
      event_settings_attributes: [:event_type, :create_channel, :notify_participants, :remind_server, :restricted])
  end

  def team_params
    params.require(:team).permit(:name)
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

  def get_participant
    @participant = Participant.find_by(member_id: @membership.id, event_id: @event.id)
  end

  def load_bot
    @bot = Discord::Bot.new(id: @community.server_id)
  end

  def send_notification(nickname, embed = nil)
    Thread.new do
      channel = @community.get_main_channel
      @bot.send_to_channel(channel, @event.send("#{action_name}_notification", nickname), embed) if channel
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

  def find_or_create_games(params)
    games = []
    params.each do |key, game_params|
      if game_params['id']
        games << Game.find_by(id: game_params['id'])
      else
        game = Game.new(game_params)
        games << game
      end
    end
    games
  end

  def allowed_fetch_params
    %w(past upcoming live)
  end

  def scope_set_and_valid?
    params[:scope] && allowed_fetch_params.include?(params[:scope])
  end
end
