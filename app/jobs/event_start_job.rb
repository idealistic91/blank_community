class EventStartJob < ApplicationJob
    queue_as :default
    discard_on ActiveRecord::RecordNotFound
    discard_on AASM::InvalidTransition
    
    rescue_from(StandardError) do |e|
        backtrace = e.backtrace.select{|line| line =~ /blank_app/i }.map{|b| "**#{b}**" }.join("\n")
        message = "Exception raised in Job **#{self}**\nException: **#{e.message}**\nBacktrace:\n"
        begin
            bot = Discord::Bot.new(id: ENV['dev_server_id'])
            bot.send_to_channel(ENV['dev_server_channel'], "#{message}#{backtrace}")
        rescue
            bot = Discord::Bot.new(id: ENV['dev_server_id'])
            bot.send_to_channel(ENV['dev_server_channel'], "#{message}#{backtrace}")
        end
    end

    def perform(event_id)
        event = Event.find(event_id)
        event.start!
    end
end