class EventSettings < ApplicationRecord
    belongs_to :event

    after_save :check_changes

    EVENT_TYPES = {default: 'Standard', versus: 'Versus'}
    NOTIFY_PARTICIPANTS = {dont: nil, five_min_before: 5.minutes, fiveteen_min_before: 15.minutes,
                           half_an_hour_before: 30.minutes, hour_before: 1.hour}

    def dont_notify?
        notify_participants == 'dont'
    end

    def remind_server_has_changed?
        self.remind_server != self.remind_server_before_last_save
    end

    def notify_participants_changed?
        self.notify_participants != self.notify_participants_before_last_save
    end

    def check_changes
        if remind_server_has_changed? || notify_participants_changed?
            reinitialize_jobs
        end
    end

    def reinitialize_jobs
        event.reinitialize_jobs
    end
end
