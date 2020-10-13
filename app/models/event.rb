class Event < ApplicationRecord

    include DiscordNotifications

    has_many :hosting_events
    has_many :participants
    has_many :members, through: :hosting_events
    has_many :members, through: :participants
    belongs_to :game
    has_many_attached :images

    validates :start_at, presence: true
    validates :ends_at, presence: true
    validates :title, presence: true

    scope :including_game, -> { includes(:game) }

    def game_name
        game ? game.name : nil
    end

    def hosts
        hosting_events.includes(:member).map(&:member)
    end
end
