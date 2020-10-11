module DiscordNotifications
    extend ActiveSupport::Concern

    include Rails.application.routes.url_helpers

    def join_notification(name)
        "**#{name}** ist dem Event **#{title}** beigetreten"
    end

    def created_notification(name)
        "**#{name}** hat ein neues Event erstellt:\n#{event}\n#{event_url(self)}"
    end

    def event_notification
        ":mega: `#{title}`\n:video_game: `#{game ? game_name : 'Nicht vorhanden' }`"
    end

    def cancel_notification(name)
        "Das Event **#{title}** wurde von **#{name}** abgesagt!"
    end

end