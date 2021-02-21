class EventFinishJob < ApplicationJob
    discard_on ActiveRecord::RecordNotFound
    discard_on AASM::InvalidTransition
    retry_on VoiceChannelUsedException, wait: 2.minutes

    def perform(event_id)
        event = Event.find(event_id)
        if event.voice_channel_empty?
            event.finish!
        else
            event.send_to_event_channel("Ich sehe ihr seid noch zu Gange. Sobald ihr den Voice-Channel verlasst werde ich die Channel löschen.")
            raise VoiceChannelUsedException
        end
    end
end