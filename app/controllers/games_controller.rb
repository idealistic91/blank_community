class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token


  require 'json'

  # GET /games
  # GET /games.json
  def index
    @games = Game.all
  end

  # GET /games/1
  # GET /games/1.json
  def show
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(game_params)
    if game_params[:title_picture]
      @game.title_picture.attach(game_params[:title_picture])
    end
    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.js {
          template = render_to_string partial: 'events/game_selection', content_type: 'text/html'
          render json: { template: template, game_id: @game.id, success: 'true' }
        }
      else
        format.js {
          flash[:alert] = @game.errors.full_messages.join(', ') 
          template = render_to_string partial: 'layouts/flash', content_type: 'text/html', locals: { flash: flash }
          render json: { template: template, success: 'false' } 
        }
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def search
    unless params[:search].nil?
      response = $igdb_base.search_game(params[:search])
      results = response.map do |game|
        { id: game['id'], text: game['name'] }
      end
     
      respond_to do |format|
        format.js {
            render json: results
        }
      end
    end
  end

  def get_igdb_game
    # Change name
    # Check if game exist first
    game = Game.where(igdb_id: params[:igdb_id]).first
    unless game
      igdb_game = $igdb_base.game(params[:igdb_id], fields: ['name', 'cover.url']).first
      if igdb_game.nil?
        igdb_game = $igdb_base.game(params[:igdb_id], fields: ['name', 'cover.url']).first
      end
      if igdb_game.nil?
        flash[:alert] = "Das Spiel konnte nicht hinzugefügt werden ..."
        render_flash_as_json
      end
    end
    cover_url = game ? game.cover_url(format: 'cover_small') : igdb_game['cover']['url'].gsub('thumb', 'cover_small')
    name = game ? game.name : igdb_game['name']
    game_fields = render_to_string partial: 'events/partials/game_fields',
    locals: {image_url: cover_url, igdb_id: params[:igdb_id], name: name, id: game ? game.id : nil }, layout: false
    render json: { fields: game_fields }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def game_params
      params.require(:game).permit(:name, :description, :title_picture)
    end
end
