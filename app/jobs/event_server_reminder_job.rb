class EventServerReminderJob < ApplicationJob
    queue_as :default
    discard_on ActiveRecord::RecordNotFound

    def perform(event_id)
        event = Event.find(event_id)
        if event.participants_missing? && !event.locked?
            event.community.send_to_main_channel(event.state_report, event.event_embed)
        end
    end
end