module Discord
    class Bot < Server
        
        include Rails.application.routes.url_helpers
        
        attr_accessor :bot

        def initialize
            @bot = Discordrb::Bot.new token: BOT_TOKEN, client_id: CLIENT_ID
        end

        def send_to_channel(name, content = nil, embed = nil, tts = false)
            id = Server.get_channel_id(name)
            if embed
                self.bot.send_message(id, content, tts, embed)

            else
                self.bot.send_message(id, content)
            end
        end

        def build_registration_link(id)
            new_user_registration_url(discord_id: id)
        end
    end
end