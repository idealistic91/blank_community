module Discord
    class Server < Base
        def self.channels
            channels = Discordrb::API::Server.channels(BOT_TOKEN, SERVER_ID)
            channels = JSON.parse(channels.to_str)
        end

        def self.members
            members = Discordrb::API::Server.resolve_members(BOT_TOKEN, SERVER_ID, 100)
            members = JSON.parse(members.to_str)
        end

        def self.roles
            roles = Discordrb::API::Server.roles(BOT_TOKEN, SERVER_ID)
            roles = JSON.parse(roles.to_str)
        end

        def self.role(id)
            roles.select{|r| r['id'] == id }.first
        end

        def self.member_by(value)
            by_name = value.is_a?(String) ? true : false
            res = members.select{|m| m['user'][by_name ? 'username' : 'id'] == value.to_s }.first
            return nil if res.nil?
            res['role_names'] = res['roles'].map{ |r| role(r)['name'] }
            res
        end

        def member_roles(name)
            member_by(name)['role_names']
        end

        def self.text_channels
            channels.select do |c|
                c['type'] == 0 
            end
        end

        def self.voice_channels
            channels.select do |c|
                c['type'] == 2 
            end
        end

        def self.get_channel_id(name, type = :text)
            channel = self.send("#{type}_channels").select do |c|
                c['name'] == name
            end
            channel.first['id']
        end
    end
end