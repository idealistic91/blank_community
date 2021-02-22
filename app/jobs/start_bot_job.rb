class StartBotJob < ApplicationJob
    queue_as :default

    def perform
        Discord::EventHandler.run
    end
end