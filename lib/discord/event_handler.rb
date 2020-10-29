module Discord
    class EventHandler < Base
        def self.run
            DISCORD_BOT.bot.message(with_text: 'Ping!') do |event|
                authorize(event) do
                    event.respond 'Pong!!'
                end
            end
            
            DISCORD_BOT.bot.message(with_text: 'events:all') do |event|
                authorize(event) do
                    events = Event.upcoming_events.include_game_members
                    if events
                        event.respond 'Gib mir einen Moment!'
                        embeded_events = events.map(&:event_notification)
                        embeded_events.each do |message|
                            event.respond message
                        end
                        event.respond "Tippe 'event:<id>' für mehr Informationen."    
                    else
                        event.respond "Keine Events gefunden..."
                    end
                end
            end
            
            DISCORD_BOT.bot.message(with_text: /event:\d*/) do |event|
                authorize(event) do
                    id = event.message.content.gsub('event:', '')
                    e = Event.include_game_members.find_by(id: id)
                    if e
                        event.respond nil, false, e.event_embed_small
                    else
                        event.respond 'Event nicht gefunden!' 
                    end
                end
            end
            
            DISCORD_BOT.bot.message(with_text: 'git-repo!') do |event|
                event.respond ENV["git_repo"]
            end
            
            DISCORD_BOT.bot.message(with_text: 'event:last') do |event|
                authorize(event) do
                    e = Event.include_game_members.last
                    if e
                        event.respond nil, false, e.event_embed_small
                    else
                        event.respond 'Zur Zeit gibt es keine Events' 
                    end
                end
            end
            
            DISCORD_BOT.bot.message(with_text: 'events:mine') do |event|
                authorize(event) do |user|
                    if user.member.hosting_events.any?
                        event.respond 'Gib mir einen Moment!'
                        events = user.member.hosting_events.map(&:event)
                        embeded_events = events.map(&:event_notification)
                        embeded_events.each do |message|
                            event.respond message
                        end
                    else
                        event.respond 'Du hast noch kein Event erstellt!'
                    end  
                end
            end
            
            DISCORD_BOT.bot.message(with_text: 'register:me') do |event|
                author = event.message.author
                id = author.id
                author.pm("Hallo #{author.display_name}\n**Registriere dich hier:**\n#{DISCORD_BOT.build_registration_link(id)}")
                event.respond "@#{author.display_name}\nIn deinem Postfach findest du einen Registrierungslink\nTeile diesen mit niemanden!"
            end

            DISCORD_BOT.bot.run
        end

        def self.authorize(event)
            user = User.find_by_discord_id(event.message.author.id)
            if user
                yield(user)
            else
                event.respond "Du hast blank_community noch nicht mit discord verbunden!\nTippe 'register:me' um einen Registrierungslink zu erhalten"
            end
        end
    end
end