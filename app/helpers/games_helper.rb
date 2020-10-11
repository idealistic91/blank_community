module GamesHelper
    def picture_url(game, type:)
        if game
            game.send(type).attached? ? url_for(game.send(type)) : nil
        else
            nil
        end
    end

    def game_picture(game, options = {})
        if picture_url(game, type: :title_picture)
            options ? (image_tag picture_url(game, type: :title_picture), options): (image_tag picture_url(game, type: :title_picture))
        else
            nil
        end
    end

    def index_picture(game, options = {})
        if picture_url(game, type: :index_picture)
            options ? (image_tag picture_url(game, type: :index_picture), options): (image_tag picture_url(game, type: :index_picture))
        else
            nil
        end
    end
end
