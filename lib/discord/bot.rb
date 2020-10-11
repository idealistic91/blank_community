module Discord
    class Bot < Server
        
        attr_accessor :bot

        def initialize
            @bot = Discordrb::Bot.new token: BOT_TOKEN, client_id: CLIENT_ID
        end

        def send_to_channel(name, content)
            id = Server.get_channel_id(name)
            self.bot.send_message(id, content)
        end

        def prepair_register_link
            
        end
    end
end