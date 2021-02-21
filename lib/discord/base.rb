module Discord
    class Base
        extend CustomRescue
        
        CLIENT_ID = ENV['client_id']
        CLIENT_SECRET = ENV['client_secret']
        SERVER_ID = ENV['server_id']
        USER_TOKEN = ENV['user_token']
        BOT_TOKEN = ENV['bot_token']
        
        def self.notifiy_dev_team(e)
            backtrace = e.backtrace.select{|line| line =~ /blank_app/i }.map{|b| "**#{b}**" }.join("\n")
            message = "Exception raised\nException: **#{e.message}**\nBacktrace:\n"
            bot = Discord::Bot.new(id: ENV['dev_server_id'])
            bot.send_to_channel(ENV['dev_server_channel'], "#{message}#{backtrace}")
        end
    end
end