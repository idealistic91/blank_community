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
    validates :slots, inclusion: 3..10
    validate :max_slots_reached, on: :update

    before_create :set_end_date
    before_update :set_end_date

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

    def add_host(member_id)
        self.hosting_events << HostingEvent.create(event_id: id, member_id: member_id)
        self.save
        host_join_event
    end

    def event_full?
        slots == members.size
    end

    private

    def max_slots_reached
        errors.add(:slots, "Leider ist kein Platz mehr!") if event_full?
    end
    
    def host_join_event
        if hosts.any?
            hosts.each { |host| members << host unless members.include?(host) }
        end
        self.save
    end

    def set_end_date
        if self.ends_at <= self.start_at
            self.ends_at = self.ends_at + 1.day
        end
    end
end
