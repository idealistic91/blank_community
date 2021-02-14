module DiscordNotifications
    extend ActiveSupport::Concern

    include Rails.application.routes.url_helpers

    def join_notification(name)
        "**#{name}** ist dem Event **#{title}** beigetreten"
    end

    def create_notification(name)
        "**#{name}** hat ein neues Event erstellt:"
    end

    def event_notification
        ":hash: `#{id}` :mega: `#{title}` :video_game: `#{games.any? ? games.map(&:name).join(';') : 'Nicht vorhanden' }` :date: `#{I18n.l(date)}` :clock4: `#{I18n.l(start_at)}` :clock11: `#{I18n.l(ends_at)}`"
    end

    def send_poll_notification(name)
        "**#{name}** hat eine Umfrage gestartet"
    end

    def event_embed
        embed = {
            "title": "Event: #{title}",
            "description": "#{description}\n:video_game:`#{games.any? ? games.map(&:name).join(',') : 'Nicht vorhanden' }`",
            "url": "#{community_event_url(self.community, self)}",
            "color": 15682568,
            "timestamp": "#{Time.now.utc.iso8601}",
            "footer": {
                "icon_url": "#{self.hosts.first.discord_avatar}",
                "text": "footer text"
            },
            "author": {
                "name": "#{self.hosts.first.nickname}",
                "url": "#{root_url}",
                "icon_url": "#{self.hosts.first.discord_avatar}"
            },
            "fields": [
                    {
                        "name": "Plätze",
                        "value": "#{self.members.size}/#{slots}"
                    },
                    {
                        "name": "Start",
                        "value": "#{I18n.l(start_at, format: :short)}",
                        "inline": true
                    },
                    {
                        "name": "Ende",
                        "value": "#{I18n.l(ends_at, format: :short)}",
                        "inline": true
                    },
                    {
                        "name": "Actions",
                        "value": "[Join](#{public_join_community_events_url(community_id: self.community, id: self.id, secure: true)})"
                    }
                ]
        }
        if games.any?
            embed["thumbnail"] = {
                "url": "https:#{games.first.cover_url(format: 'cover_small')}"
            }
        end
        embed
    end

    def destroy_notification(name)
        "Das Event **#{title}** wurde von **#{name}** abgesagt!"
    end

    def leave_notification(name)
        "**#{name}** nimmt nicht mehr am Event **#{title}** teil!"
    end
end