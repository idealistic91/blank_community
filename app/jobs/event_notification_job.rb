class EventNotificationJob < ApplicationJob
    queue_as :default
    discard_on ActiveRecord::RecordNotFound

    def perform(event_id)
        event = Event.find(event_id)
        unless event.locked?
            event.notify_participants(event.notifiy_message)
        end
    end
end