class GamesController < ApplicationController
  include CustomRescue
  
  def search
    unless params[:search].nil?
      response = rescue_igdb_base do
        $igdb_base.search_game(params[:search])
      end
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
    game = Game.where(igdb_id: params[:igdb_id]).first
    unless game
      igdb_game = $igdb_base.game(params[:igdb_id], fields: ['name', 'cover.url']).first
      if igdb_game.nil?
        flash[:alert] = "Es gab einen Fehler beim Hinzfügen des Spiel's - versuche es erneut!"
        render_flash_as_json
      end
    end
    cover_url = game ? game.cover_url(format: 'cover_small') : igdb_game['cover']['url'].gsub('thumb', 'cover_small')
    name = game ? game.name : igdb_game['name']
    game_fields = render_to_string partial: 'events/partials/game_fields',
    locals: {image_url: cover_url, igdb_id: params[:igdb_id], name: name, id: game ? game.id : nil }, layout: false
    render json: { fields: game_fields }
  end
end
