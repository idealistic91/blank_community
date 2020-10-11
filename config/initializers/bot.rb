DISCORD_BOT = Discord::Bot.new
    
DISCORD_BOT.bot.message(with_text: 'Ping!') do |event|
    event.respond 'Pong!!'
end

DISCORD_BOT.bot.message(with_text: 'Events!') do |event|
    events = Event.all.map do |e|
        e.event_notification
    end
    event.respond events.join("\n-------------------\n")
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
    id = event.message.author.id
    event.respond "Gib mir einen Moment #{event.message.author.username}\n**Registriere dich hier:**\n#{DISCORD_BOT.build_registration_link(id)}"
end

if Rails.env.production?
    DISCORD_BOT.bot.run(:async)
end
