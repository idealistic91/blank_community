module Discord
    class Server < Base
        
        attr_accessor :id, :this, :bot
        
        def initialize(id:, bot: nil)
            @id = id
            @bot = bot || DISCORD_BOT.bot
            @this = Discordrb::Server.new(info, bot)
        end
        
        def channels
            channels = Discordrb::API::Server.channels(BOT_TOKEN, id)
            JSON.parse(channels.to_str)
        end

        def system_channel
            this.system_channel
        end

        def create_channel(name, type = :text, parent = nil)
            type_id = {
                text: 0,
                voice: 2,
                category: 4,
                news: 5,
                store: 6
            }[type]
            this.create_channel(name, type_id, topic: nil, bitrate: nil, user_limit: nil, permission_overwrites: nil, parent: parent, nsfw: false, rate_limit_per_user: nil, position: nil, reason: nil)
        end

        def download_icon
            url = this.icon_url
            image = Net::HTTP.get(URI.parse(url))
            return image
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

        def find_channel_by_id(id)
            data = self.channels.select do |c|
                c['id'] == id
            end
            return nil unless data.any?
            Discordrb::Channel.new(data, bot)
        end

        def get_channel(name, type = :text)
            data = self.send("#{type}_channels").select do |c|
                c['name'] == name
            end
            return nil unless data.any?
            Discordrb::Channel.new(data, bot)
        end
    end
end