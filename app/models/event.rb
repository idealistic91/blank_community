class Event < ApplicationRecord
    include AASM
    include DiscordNotifications
    require 'sidekiq/api'
    # Todo: Move this to event settings model
    MIN_SLOTS = 3
    MAX_SLOTS = 20
    EVENT_JOBS = %w(EventFinishJob EventStartJob)

    has_many :hosting_events, dependent: :destroy
    has_many :participants, dependent: :destroy
    has_many :members, through: :hosting_events
    has_many :members, through: :participants
    has_many :event_games, dependent: :destroy
    has_many :games, through: :event_games
    has_many_attached :images
    belongs_to :community

    validates :start_at, presence: true, on: :create
    validates :start_at, future: true, on: :create
    validates :ends_at, presence: true, on: :create
    validates :ends_at, future: true, on: :create
    validates :date, presence: true
    validates :title, presence: true
    validates :slots, inclusion: { in: Proc.new{ |event| event.slot_range } }
    validate :check_state, on: :update
    validate :max_slots_reached, on: :update

    before_create :set_end_date
    before_update :set_end_date
    after_create_commit :initialize_jobs
    after_destroy :delete_jobs

    scope :include_game_members, -> { includes(:members, :games) }
    scope :upcoming_events, -> { where('start_at > ?', DateTime.now) }
    scope :past_events, -> { where('ends_at < ?', DateTime.now) }
    scope :live_events, -> { where(state: 'started') }

    aasm column: 'state', no_direct_assignment: true do
        state :ready, initial: true
        state :being_planned
        state :started
        state :finished

        event :prepare do
            transitions from: :being_planned, to: :ready
        end
        
        event :start, after_commit: :event_starting_actions do
            transitions from: :ready, to: :started
        end

        event :finish, after_commit: :event_finished_actions do
            transitions from: :started, to: :finished
        end
    end

    def game_name
        game ? game.name : nil
    end

    def slot_range
        members.size > MIN_SLOTS ? (members.size..MAX_SLOTS) : (MIN_SLOTS..MAX_SLOTS)
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

    def join(member)
        if event_upcoming?
            members << member
            true
        else
            false
        end
    end

    def leave(member)
        unless started? || finished?
            members.delete(member)
            return true
        end
        errors.add(:base, "Event mit dem Status #{state} können nicht verlassen werden.")
        return false
    end

    def voice_channel_empty?
        !voice_channel.users.any?
    end

    def send_to_event_channel(message)
        text_channel.send_message(message)
    end

    private

    def event_upcoming?
        finished = start_at < DateTime.now
        if finished
            errors.add(:base, 'Event liegt in der Vergangenheit!')
            return false
        end
        true
    end

    def locked?
        self.started? || self.finished?
    end

    def check_state
        if locked?
            unless self.changed.include?('state')
                errors.add(:base, 'Das Event kann nicht mehr bearbeitet werden.')
                return false
            end
        end
    end

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

    def notify_discord(message)
        bot = Discord::Bot.new(id: community.server_id)
        main_channel = community.get_main_channel
        if main_channel
            bot.send_to_channel(main_channel, message)
        end
    end

    def notify_participants
        members.each do |m|
            m.send_message("Das Event **#{id}##{title}** ist gestartet!\n Bitte begib dich in den Event-Channel um deine Anwesenheit zu zeigen.")
        end
    end

    def event_starting_actions
        # notify discord channel (main channel set by community)
        update_columns(ends_at: Time.current + ActiveSupport::Duration.build(ends_at - start_at),
            start_at: Time.current,
            date: Date.today)
        notify_discord("Das Event **#{id}##{title}** startet bald!")

        # create channels (text channel and voice channel)
        create_channels
        notify_participants
    end

    def event_finished_actions
        # get media from text channel (later)
        # notify discord
        update_attribute(:ends_at, Time.current)
        notify_discord("Das Event **#{id}##{title}** wurde beendet. Ich räume für euch auf! :broom:")
        # delete channels
        delete_channels
    end

    def create_channels
        category_channel = community_server.create_channel("Event: #{title}", :category)
        community_server.create_channel("event-chat", :text, category_channel)
        community_server.create_channel("event-voice", :voice, category_channel)
        update_attribute(:channel_id, category_channel.id.to_s)
        bot = Discord::Bot.new(id: community.server_id)
        main_channel = community.get_main_channel
        if main_channel
            bot.send_to_channel(main_channel, "Ich habe euch zwei Channel für das Event **#{title}** erstellt.")
        end
    end

    def community_server
        community.server
    end

    def channel_wrapper
        community_server.find_channel_by_id(channel_id)
    end

    def event_channels
        channel_wrapper.children
    end

    def voice_channel
        event_channels.select{|channel| channel.type == 2 }.first
    end

    def text_channel
        event_channels.select{|channel| channel.type == 0 }.first
    end

    def delete_channels
        if voice_channel_empty?
            event_channels.map(&:delete)
            channel_wrapper.delete
        end
    end
    
    def initialize_jobs
        EventStartJob.set(wait_until: start_at).perform_later(id)
        EventFinishJob.set(wait_until: ends_at).perform_later(id)
    end

    def delete_jobs
        return true unless Rails.env.production?
        queues = Sidekiq::ScheduledSet.new
        sidekiq_entries = queues.select do |sorted_entry|
            job_data = sorted_entry.args.first
            return false unless EVENT_JOBS.include?(job_data['job_class'])
            return true if job_data['arguments'].include?(id)
            return false
        end
        sidekiq_entries.map(&:delete)
    end
end
