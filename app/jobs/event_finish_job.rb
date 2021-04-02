class EventFinishJob < ApplicationJob
    queue_as :default
    discard_on ActiveRecord::RecordNotFound
    discard_on AASM::InvalidTransition
    retry_on VoiceChannelUsedException, wait: 30.minutes

    def perform(event_id)
        event = Event.find(event_id)
        return false if event.finished?
        if event.voice_channel_empty?
            event.finish!
        else
            raise VoiceChannelUsedException
        end
    end
end