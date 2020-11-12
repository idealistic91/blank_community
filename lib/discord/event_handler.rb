module Discord
    class EventHandler < Base
        def self.run
            DISCORD_BOT.bot.message(with_text: 'Ping!') do |event|
                authorize(event) do
                    event.respond 'Pong!!'
                end
            end
            
            DISCORD_BOT.bot.message(with_text: 'events:all') do |event|
                find_community(event) do |community, user|
                    events = community.events.include_game_members.upcoming_events
                    if events.any?
                        event.respond 'Gib mir einen Moment!'
                        embeded_events = events.map(&:event_notification)
                        embeded_events.each do |message|
                            event.respond message
                        end
                        event.respond "Tippe 'event:<id>' für mehr Informationen."    
                    else
                        event.respond "Es stehen keine Events an"
                    end
                end
            end
            
            DISCORD_BOT.bot.message(with_text: /event:\d*/) do |event|
                find_community(event) do |community, user|
                    id = event.message.content.gsub('event:', '')
                    e = community.events.include_game_members.find_by(id: id)
                    if e
                        event.respond nil, false, e.event_embed
                    else
                        event.respond 'Event nicht gefunden!' 
                    end
                end
            end
            
            DISCORD_BOT.bot.message(with_text: 'git-repo!') do |event|
                event.respond ENV["git_repo"]
            end
            
            DISCORD_BOT.bot.message(with_text: 'event:last') do |event|
                find_community(event) do |community, _user|
                    e = community.events.include_game_members.last
                    if e
                        event.respond nil, false, e.event_embed
                    else
                        event.respond 'Zur Zeit gibt es keine Events' 
                    end
                end
            end
            
            DISCORD_BOT.bot.message(with_text: 'events:mine') do |event|
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
            
            DISCORD_BOT.bot.message(with_text: 'register:me') do |event|
                find_community(event, false) do |community|
                    respond_with_register_link(event)
                end
            end
            
            DISCORD_BOT.bot.message(with_text: 'register:server') do |event|
                author_is_owner = event.author.server.owner == event.message.author
                if author_is_owner 
                    author_user = User.find_by_discord_id(event.message.author.id)
                    params = {
                        name: event.author.server.name,
                        server_id: event.author.server.id.to_s,
                        creator: author_user ? author_user : nil
                    }
                    community = Community.new(params)
                    if community.save
                        # send link to community setup page if user already exists
                        if author_user
                            event.respond "#{community.name} wurde erfolgreich angelegt!\nIch habe dir einen link zur Community via PM zugestellt."
                            # Todo: Link to community setup view/controller etc.
                        else
                            respond_with_register_link(event)
                        end
                    else
                        event.respond "Folgende Fehler haben das Registrieren verhindert:\n#{community.errors.full_messages.join(', ')}"
                    end
                else
                    event.respond "Nur Besitzer können den Server registrieren!\nUm dich als Benutzer zu registrieren tippe `register:server`"
                end
                # Create a community with given server id unless it already exists
                # Check if author is owner of the server
            end

            DISCORD_BOT.bot.run
        end

        def self.authorize(event)
            user = User.find_by_discord_id(event.message.author.id)
            if user
                yield(user)
            else
                event.respond "Du hast blank_community noch nicht mit discord verbunden!\nTippe 'register:me' um einen Registrierungslink zu erhalten"
            end
        end

        def self.respond_with_register_link(event)
            event.message.author.pm("Hallo #{event.message.author.display_name}\n**Registriere dich hier:**\n#{DISCORD_BOT.build_registration_link(event.message.author.id, event.message.author.server.id)}")
            event.respond "@#{event.message.author.display_name}\nIn deinem Postfach findest du einen Registrierungslink\nTeile diesen mit niemanden!"
        end

        def self.find_community(event, authorize = true)
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
                event.respond "Dieser Server ist noch nicht mit der App verbunden\nTippe als Besitzer 'register:server'"
            end
        end
    end
end