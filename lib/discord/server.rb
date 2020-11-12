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

        def members
            members = Discordrb::API::Server.resolve_members(BOT_TOKEN, id, 100)
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

        def member_by(value)
            by_name = value.is_a?(String) ? true : false
            res = members.select{|m| m['user'][by_name ? 'username' : 'id'] == value.to_s }.first
            return nil if res.nil?
            res['role_names'] = res['roles'].map{ |r| role(r) ? role(r)['name'] : '' }
            res
        end

        def member_roles(name)
            member_by(name)['role_names']
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