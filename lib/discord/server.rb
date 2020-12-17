module Discord
    class Server < Base
        
        attr_accessor :id
        
        def initialize(id:)
            @id = id
        end
        
        def channels
            channels = Discordrb::API::Server.channels(BOT_TOKEN, id)
            JSON.parse(channels.to_str)
        end

        def info
            info = Discordrb::API::Server.resolve(BOT_TOKEN, id)
            JSON.parse(info.to_str)
        end

        def members
            members = Discordrb::API::Server.resolve_members(BOT_TOKEN, id, 150)
            JSON.parse(members.to_str)
        end

        def roles
            roles = Discordrb::API::Server.roles(BOT_TOKEN, id)
            JSON.parse(roles.to_str)
        end

        def role(id)
            result = roles
            if result.nil?
                nil
            else
                result = roles
                result = result.select{|r| r['id'] == id }
                result.first if result.any?
            end
        end

        def get_member_by_id(discord_id)
            begin
                member = Discordrb::API::Server.resolve_member(BOT_TOKEN, id, discord_id)
                return JSON.parse(member)
            rescue RestClient::NotFound => exception
                return false
            end
        end

        def text_channels
            channels.select do |c|
                c['type'] == 0 
            end
        end

        def voice_channels
            channels.select do |c|
                c['type'] == 2 
            end
        end

        def get_channel_id(name, type = :text)
            channel = self.send("#{type}_channels").select do |c|
                c['name'] == name
            end
            return nil unless channel.any?
            channel.first['id']
        end
    end
end