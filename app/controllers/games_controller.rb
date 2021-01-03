class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]

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
