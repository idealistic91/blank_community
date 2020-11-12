class Event < ApplicationRecord

    include DiscordNotifications

    has_many :hosting_events
    has_many :participants, dependent: :destroy
    has_many :members, through: :hosting_events
    has_many :members, through: :participants
    has_many_attached :images
    belongs_to :game, optional: true
    belongs_to :community

    validates :start_at, presence: true
    validates :ends_at, presence: true
    validates :date, presence: true
    validates :title, presence: true 

    before_create :set_end_date
    before_update :set_end_date
    after_create :host_join_event

    scope :including_game, -> { includes(:game) }
    scope :include_game_members, -> { includes(:game, :members) }
    scope :upcoming_events, -> { where('date > ?', DateTime.now) }
    scope :past_events, -> { where('date < ?', DateTime.now) }

    def game_name
        game ? game.name : nil
    end

    def hosts
        hosting_events.includes(:member).map(&:member)
    end
    
    private
    
    def set_end_date
        if self.ends_at <= self.start_at
            self.ends_at = self.ends_at + 1.day
        end
    end

    def host_join_event
        hosts.each { |host| members << host }
    end
end
