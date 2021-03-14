class EventSettings < ApplicationRecord
    belongs_to :event

    EVENT_TYPES = {default: 'Standard', versus: 'Versus'}
    NOTIFY_PARTICIPANTS = {dont: nil, five_min_before: 5.minutes, fiveteen_min_before: 15.minutes, half_an_hour_before: 30.minutes, hour_before: 1.hour}

    def dont_notify?
        notify_participants == 'dont'
    end
end
