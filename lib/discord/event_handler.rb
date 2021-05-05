module Discord
    class EventHandler < Base
        def self.run
            DISCORD_BOT_SYNC.bot.message(with_text: 'Ping!') do |event|
                authorize(event) do
                    event.respond 'Pong!!'
                end
            end

            DISCORD_BOT_SYNC.bot.message(with_text: '!help') do |event|
                if Rails.env.development?
                    begin
                        throw :abort unless event.author.server.id.to_s == ENV['dev_server_id']
                    rescue
                        return false
                    end
                end
                event.respond "**register:me** - Registriere dich\n**register:server** - Registriere den Server als Besitzer\n**events:all** - Rufe alle bevorstehenden Events auf\n**event:<id>** - Rufe ein bestimmtes Event auf\n**events:mine** - Liste meine Events auf\n**event:<id>:start** - Starte ein Event manuell\n**event:<id>:finish** - Beende ein Event manuell\n**event:last** - Rufe das zuletzt erstelle Event auf"
            end
            
            DISCORD_BOT_SYNC.bot.message(with_text: 'events:all') do |event|
                find_community(event) do |community, user|
                    events = community.events.upcoming_events
                    if events.any?
                        event.respond 'Gib mir einen Moment!'
                        embeded_events = events.map(&:event_notification)
                        embeded_events.each do |message|
                            event.respond message
                        end
                        event.respond "Tippe **event:<id>** für mehr Informationen."    
                    else
                        event.respond "Es stehen keine Events an"
                    end
                end
            end
            
            DISCORD_BOT_SYNC.bot.message(with_text: /event:\d*/) do |event|
                find_community(event) do |community, user|
                    id = event.message.content.gsub('event:', '')
                    e = community.events.find_by(id: id)
                    if e
                        event.respond nil, false, e.event_embed
                    else
                        event.respond 'Event nicht gefunden!' 
                    end
                end
            end

            DISCORD_BOT_SYNC.bot.message(with_text: /event:\d*:start/) do |event|
                find_community(event) do |community, user, membership|
                    id = event.message.content.gsub('event:', '').gsub(':start', '')
                    e = community.events.find_by(id: id)
                    if e && e.hosts.include?(membership)
                        begin
                            e.start!
                        rescue StandardError => e
                            event.respond "Fehler: #{e.message}"
                        end
                    else
                        event.respond 'Du bist kein Host für dieses Event oder das Event wurde nicht gefunden!' 
                    end
                end
            end

            DISCORD_BOT_SYNC.bot.message(with_text: /event:\d*:finish/) do |event|
                find_community(event) do |community, user, membership|
                    id = event.message.content.gsub('event:', '').gsub(':finish', '')
                    e = community.events.find_by(id: id)
                    if e && e.hosts.include?(membership)
                        begin
                            e.finish!
                        rescue StandardError => e
                            event.respond "Fehler: #{e.message}"
                        end
                    else
                        event.respond 'Du bist kein Host für dieses Event oder das Event wurde nicht gefunden!' 
                    end
                end
            end
            
            DISCORD_BOT_SYNC.bot.message(with_text: 'git-repo!') do |event|
                event.respond ENV["git_repo"]
            end
            
            DISCORD_BOT_SYNC.bot.message(with_text: 'event:last') do |event|
                find_community(event) do |community, _user|
                    e = community.events.last
                    if e
                        event.respond nil, false, e.event_embed
                    else
                        event.respond 'Zur Zeit gibt es keine Events' 
                    end
                end
            end
            
            DISCORD_BOT_SYNC.bot.message(with_text: 'events:mine') do |event|
                find_community(event) do |community, user, membership|
                    if membership.hosting_events.any?
                        event.respond 'Gib mir einen Moment!'
                        events = membership.hosting_events.map(&:event)
                        embeded_events = events.map(&:event_notification)
                        embeded_events.each do |message|
                            event.respond message
                        end
                    else
                        event.respond 'Du hast noch kein Event erstellt!'
                    end  
                end
            end
            
            DISCORD_BOT_SYNC.bot.message(with_text: 'register:me') do |event|
                find_community(event, false) do |community|
                    user = user(event)
                    if user
                        result = user.create_membership(community)
                        if result[:success]
                            event.message.author.pm("Du bist jetzt Mitglied der #{community.name} Community!")
                            event.message.author.pm("Hier geht es zur Community: #{DISCORD_BOT_SYNC.build_community_config_link(community.id)}")
                        else
                            event.message.author.pm("Fehler beim Erstellen der Mitgliedschaft: #{result[:message]}")
                        end
                    else
                        respond_with_register_link(event)
                    end
                end
            end
            
            DISCORD_BOT_SYNC.bot.message(with_text: 'register:server') do |event|
                if author_is_owner?(event) 
                    author_user = user(event)
                    if author_user
                        params = {
                            name: event.author.server.name,
                            server_id: event.author.server.id.to_s,
                            creator: author_user
                        }
                        community = Community.new(params)
                        if community.save
                            respond_with_community_link(event, community)
                        else
                            event.respond "Folgende Fehler haben das Registrieren verhindert:\n#{community.errors.full_messages.join(', ')}"
                        end
                    else
                        respond_with_register_link(event, true)
                    end
                else
                    event.respond "Nur Besitzer können den Server registrieren!"
                end
            end
            DISCORD_BOT_SYNC.bot.run :asnyc
        end

        def self.authorize(event)
            user = user(event)
            if user
                yield(user)
            else
                event.respond "Du hast blank_community noch nicht mit discord verbunden!\nTippe `register:me` um einen Registrierungslink zu erhalten"
            end
        end

        def self.user(event)
            User.find_by_discord_id(event.message.author.id)
        end

        def self.author_is_owner?(event)
            event.author.server.owner == event.message.author
        end

        def self.respond_with_register_link(event, with_community = false)
            if with_community
                event.message.author.pm("Hallo #{event.message.author.display_name}\n**Registriere dich und deine Community hier:**\n#{DISCORD_BOT_SYNC.build_registration_link(event.message.author.id, event.message.author.server.id)}")
            else
                event.message.author.pm("Hallo #{event.message.author.display_name}\n**Registriere dich hier:**\n#{DISCORD_BOT_SYNC.build_registration_link(event.message.author.id)}")
            end
            event.respond "@#{event.message.author.display_name}\nIn deinem Postfach findest du einen Registrierungslink\nTeile diesen mit niemanden!"
        end

        def self.respond_with_community_link(event, community)
            event.respond "#{community.name} wurde erfolgreich angelegt!\nIch habe dir einen link zu deiner Community via PM zugestellt."
            event.message.author.pm("Hier der Link zu deinen #{community.name}-community settings.\n#{DISCORD_BOT_SYNC.build_community_config_link(community.id)}")            
        end

        def self.find_community(event, authorize = true)
            if Rails.env.development?
                begin
                    throw :abort unless event.author.server.id.to_s == ENV['dev_server_id']
                rescue
                    return false
                end
            end
            community = Community.find_by(server_id: event.author.server.id)
            if community
                if authorize
                    authorize(event) do |user|
                        membership = user.memberships.by_community(community.id).first
                        if membership
                            yield(community, user, membership)
                        else
                            event.respond "Du gehörst dieser Community noch nicht an."
                        end
                    end
                else
                    yield(community)
                end
            else
                event.respond "Dieser Server ist noch nicht mit der App verbunden\nTippe als Besitzer `register:server`"
            end
        end
        # needs fixing
        # if Rails.env.production?
        #     rescue_exception with: :notifiy_dev_team
        # end
    end
end