DISCORD_BOT = Discord::Bot.new
    
DISCORD_BOT.bot.message(with_text: 'Ping!') do |event|
    event.respond 'Pong!!'
end

DISCORD_BOT.bot.message(with_text: 'events:all') do |event|
    events = Event.including_game
    event.respond events.map(&:event_notification)
                    .join("\n-------------------\n")
end

DISCORD_BOT.bot.message(with_text: 'git-repo!') do |event|
    event.respond ENV["git_repo"]
end

DISCORD_BOT.bot.message(with_text: 'event:last') do |event|
    begin
        e = Event.include_game_members.last
        if e
            event.respond nil, false, e.event_embed_small
        else
           event.respond 'Zur Zeit gibt es keine Events' 
        end
    rescue RestClient::BadRequest => e
        DISCORD_BOT.send_to_channel('app_errors', "#{e}\n#{e.response.body}\n Backtrace:\n#{e.backtrace.join("\n")}")
    end
end

DISCORD_BOT.bot.message(with_text: 'register:me') do |event|
    author = event.message.author
    id = author.id
    author.pm("Hallo #{author.display_name}\n**Registriere dich hier:**\n#{DISCORD_BOT.build_registration_link(id)}")
    event.respond "@#{author.display_name}\nIn deinem Postfach findest du einen Registrierungslink\nTeile diesen mit niemanden!"
end