DISCORD_BOT = Discord::Bot.new

# ToDo: Move these event handlers to the lib
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
# ToDo: Only run in development, later to be run on a worker


if Rails.env.development?
  DISCORD_BOT.bot.run(:async)
end