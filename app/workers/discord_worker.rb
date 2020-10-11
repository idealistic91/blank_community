class DiscordWorker
    include Sidekiq::Worker
    
    def perform
        
        #listen for Discord-user input
        
        bot = Discord::Bot.new

        bot.bot.message(with_text: 'Ping!') do |event|
            event.respond 'Pong!!'
        end
        
        bot.bot.message(with_text: 'Events!') do |event|
            events = Event.all.map do |e|
                e.event_notification
            end
            event.respond events.join("\n-------------------\n")
        end
        
        bot.bot.message(with_text: 'Users!') do |event|
            names = Discord::Server.members.map do |member|
                member['user']['username']
            end
        
            event.respond names.join("\n")
        end                  

        bot.bot.run
    end
end