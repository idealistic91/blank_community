module Discord
    class Bot < Server
        
        include Rails.application.routes.url_helpers
        
        attr_accessor :bot, :id

        def initialize(id: nil)
            @bot = Discordrb::Bot.new token: BOT_TOKEN, client_id: CLIENT_ID
            if id
                @id = id
            end
        end

        def send_to_channel(name, content = nil, embed = nil, tts = false)
            channel_id = Server.new(id: id).get_channel_id(name)
            if embed
                self.bot.send_message(channel_id, content, tts, embed)
            else
                self.bot.send_message(channel_id, content)
            end
        end

        def servers
            bot.run :async
            servers = bot.servers.map{ |server| server.first.to_s }
            bot.stop :async
            servers
        end

        def connected_servers(user_id)
            servers.map do |id|
                Discord::Server.new(id: id).member_by(user_id)
            end
        end

        def build_registration_link(id, server_id = nil)
            params = { discord_id: id }
            params[:server_id] = server_id if server_id
            new_user_registration_url(params)
        end

        def build_community_config_link(id)
            edit_community_url(id)
        end
    end
end