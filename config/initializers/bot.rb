require 'discord/base'
require 'discord/server'
require 'discord/bot'

DISCORD_BOT ||= Discord::Bot.new
DISCORD_BOT_SYNC = Discord::Bot.new
InitializerHelpers.skip_console do
    StartBotJob.perform if Rails.env.production? && !defined?(Rails::Server)
end

DISCORD_BOT.bot.run :async
