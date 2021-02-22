require 'discord/base'
require 'discord/server'
require 'discord/bot'

DISCORD_BOT ||= Discord::Bot.new
DISCORD_BOT_SYNC = Discord::Bot.new
Discord::EventHandler.run if (defined? Rails::Server)
DISCORD_BOT.bot.run :async
