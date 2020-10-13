DISCORD_BOT = Discord::Bot.new
    
DISCORD_BOT.bot.message(with_text: 'Ping!') do |event|
    event.respond 'Pong!!'
end

DISCORD_BOT.bot.message(with_text: 'Events!') do |event|
    events = Event.including_game
    event.respond events.map(&:event_notification)
                    .join("\n-------------------\n")
end

DISCORD_BOT.bot.message(with_text: 'Users!') do |event|
    names = Discord::Server.members.map do |member|
        member['user']['username']
    end

    event.respond names.join("\n")
end

DISCORD_BOT.bot.message(with_text: 'git-repo!') do |event|
    event.respond ENV["git_repo"]
end

DISCORD_BOT.bot.message(with_text: 'register:me') do |event|
    author = event.message.author
    id = author.id
    author.pm("Gib mir einen Moment #{author.display_name}\n
        **Registriere dich hier:**\n#{DISCORD_BOT.build_registration_link(id)}")
    event.respond "@#{author.display_name}\n
                    In deinem Postfach findest du einen Registrierungslink\n
                    Teile diesen mit niemanden!"
end