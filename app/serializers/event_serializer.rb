class EventSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers
    attributes :id, :title, :description, :date, :start_at, :ends_at, :state, :games, :members, :hosts
    def games
        self.object.games.map do |game|
            begin
                cover_url = game.cover_url(format: 'cover_small')
            rescue => exception
                cover_url = nil
            end
            {
                id: game.id,
                name: game.name,
                igdb_id: game.igdb_id,
                cover: cover_url
            }
        end
    end

    def start_at
        I18n.l(object.start_at.to_time)
    end

    def ends_at
        I18n.l(object.ends_at.to_time)
    end

    def date
        I18n.l(object.date)
    end

    def members
        self.object.members.map do |member|
            {
                id: member.id,
                nickname: member.nickname,
                picture_url: member.user.has_picture? ? url_for(member.user.picture) : nil
            }
        end
    end

    def hosts
        self.object.hosts.map do |host|
            {
                id: host.id,
                nickname: host.nickname,
                picture_url: host.user.has_picture? ? url_for(host.user.picture) : nil
            }
        end
    end
 end