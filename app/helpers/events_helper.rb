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

    def notify_participants_collection
        [['Keine', :dont], ['5 Minuten vorher', :five_min_before],
        ['15 Minuten vorher', :fiveteen_min_before], ['30 Minuten vorher', :half_an_hour_before], ['1 Stunde vorher', :hour_before]]
    end

    def event_type_collection
        EventSettings::EVENT_TYPES.map{|key, value| [value, key]}
    end
end
