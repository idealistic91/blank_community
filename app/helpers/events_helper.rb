module EventsHelper
    def action_bar
        render layout: 'layouts/actions' do
            yield
        end
    end

    def title_picture_url(game)
        game.title_picture.attached? ? url_for(game.title_picture) : nil
    end

    def game_picture(game, options = {})
        if title_picture_url(game)
            options ? (image_tag title_picture_url(game), options) : (image_tag title_picture_url(game))
        else
            nil
        end
    end
end
