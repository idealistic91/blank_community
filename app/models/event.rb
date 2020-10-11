class Event < ApplicationRecord

    include DiscordNotifications

    belongs_to :creator, class_name: 'Member', foreign_key: :creator_id
    has_many :participants
    has_many :members, through: :participants
    has_one :game, through: :game
    has_many_attached :images

    validates :start_at, presence: true
    validates :ends_at, presence: true
    validates :title, presence: true


    def host_name_info
        creator.nickname_is_set? ? creator.nickname : creator.user.email
    end

    def game
        Game.find_by(id: game_id)
    end

    def game_name
        game ? game.name : nil
    end
end
