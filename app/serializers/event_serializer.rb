class EventSerializer < ActiveModel::Serializer
    attributes :id, :title, :description, :start_at, :ends_at, :state, :games
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
 end