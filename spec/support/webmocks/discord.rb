class DiscordApiStub
  DEFAULT_HEADERS = {
      'Accept'=>'*/*',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Authorization'=>"#{ENV['bot_token']}",
      'Host'=>'discordapp.com',
      'User-Agent'=>'DiscordBot (https://github.com/meew0/discordrb, v3.3.0) rest-client/2.1.0 ruby/2.7.1p83 discordrb/3.3.0'
  }

  attr_accessor :server_id, :members, :roles
  attr_reader :members_hash, :roles_hash, :member_names, :role_ids

  def initialize(server_id:, members: [], roles: [])
    @server_id = server_id
    @members = members
    @member_names = members.map { Faker::Internet.username }
    @roles = roles
    @roles_hash = build_role
    @role_ids = roles_hash.map{ |r| r[:id] }
    @members_hash = build_member
  end

  def build_role
    roles.map do |role_name|
      {
          "id": "#{Faker::Number.number(digits: 18)}",
          "name": role_name,
          "permissions": 104320577,
          "position": 0,
          "color": 0,
          "hoist": false,
          "managed": false,
          "mentionable": false
      }
    end
  end

  def build_member
    members.each_with_index.map do |id, i|
      {
          "user": {
              "id": "#{id}",
              "username": member_names[i],
              "avatar": SecureRandom.uuid.to_s.gsub('-', ''),
              "discriminator": "#{Faker::Number.number(digits: 4)}",
              "public_flags": 0
          },
          "roles": role_ids,
          "nick": nil,
          "premium_since": nil,
          "joined_at": "2020-10-09T10:28:09.507000+00:00",
          "is_pending": false,
          "mute": false,
          "deaf": false
      }
    end
  end

  def stub
    stub_all_members
    stub_roles
    stub_avatar_request
    stub_channels
    stub_channel
    stub_send_message
    stub_guild
    stub_member
    stub_bot
  end

  private

  def stub_all_members
    body = []
    members_hash.each do |member|
      body << member
    end
    WebMock.stub_request(:get, "https://discordapp.com/api/v6/guilds/#{server_id}/members?limit=100")
        .with(headers: DEFAULT_HEADERS)
        .to_return(status: 200, body: body.to_json, headers: {})
  end

  def stub_roles
    body = roles_hash
    WebMock.stub_request(:get, "https://discordapp.com/api/v6/guilds/#{server_id}/roles")
        .with(headers: DEFAULT_HEADERS)
        .to_return(status: 200, body: body.to_json, headers: {})
  end

  def stub_avatar_request
    WebMock.stub_request(:get, /avatars/).
        with(
            headers: {
                'Accept'=>'*/*',
                'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Host'=>'cdn.discordapp.com',
                'User-Agent'=>'Ruby'
            }).
        to_return(status: 200, body: File.read('spec/support/images/profile_picture.png'), headers: {})
  end

  def stub_channels
    body = [{"id"=>"764050415054356480", "type"=>4, "name"=>"Textkanäle", "position"=>0, "parent_id"=>nil, "guild_id"=>"#{server_id}", "permission_overwrites"=>[], "nsfw"=>false}, {"id"=>"764050415054356481", "type"=>4, "name"=>"Sprachkanäle", "position"=>0, "parent_id"=>nil, "guild_id"=>"#{server_id}", "permission_overwrites"=>[], "nsfw"=>false}, {"id"=>"764050415054356482", "last_message_id"=>"768126051330162718", "last_pin_timestamp"=>"2020-10-09T09:06:41.079000+00:00", "type"=>0, "name"=>"chat", "position"=>0, "parent_id"=>"764050415054356480", "topic"=>nil, "guild_id"=>"#{server_id}", "permission_overwrites"=>[], "nsfw"=>false, "rate_limit_per_user"=>0}, {"id"=>"764050415054356483", "type"=>2, "name"=>"Allgemein", "position"=>0, "parent_id"=>"764050415054356481", "bitrate"=>64000, "user_limit"=>0, "guild_id"=>"#{server_id}", "permission_overwrites"=>[], "nsfw"=>false}, {"id"=>"764050558990286848", "last_message_id"=>"764051530751016971", "last_pin_timestamp"=>"2020-10-09T09:08:00.292000+00:00", "type"=>0, "name"=>"events", "position"=>1, "parent_id"=>"764050415054356480", "topic"=>nil, "guild_id"=>"#{server_id}", "permission_overwrites"=>[], "nsfw"=>false, "rate_limit_per_user"=>0}, {"id"=>"766735147994710058", "last_message_id"=>"766736479074385960", "type"=>0, "name"=>"app_errors", "position"=>2, "parent_id"=>"764050415054356480", "topic"=>nil, "guild_id"=>"#{server_id}", "permission_overwrites"=>[], "nsfw"=>false, "rate_limit_per_user"=>0}]
    WebMock.stub_request(:get, "https://discordapp.com/api/v6/guilds/#{server_id}/channels").
        with(headers: DEFAULT_HEADERS).
        to_return(status: 200, body: body.to_json, headers: {})
  end

  def stub_send_message
    @member_names.each do |name|
      res_body = {
        "id": "768195988288307272",
        "type": 0,
        "content": "**#{name}** hat sein Discord mit der blank_app verbunden",
        "channel_id": "764050415054356482",
        "author": {
            "id": "764062582310436875",
            "username": "blank_web_app",
            "avatar": "09a169df66abf738561db2a57db082a4",
            "discriminator": "4986",
            "public_flags": 0,
            "bot": true
        },
        "attachments": [],
        "embeds": [],
        "mentions": [],
        "mention_roles": [],
        "pinned": false,
        "mention_everyone": false,
        "tts": false,
        "timestamp": "2020-10-20T19:36:35.999000+00:00",
        "edited_timestamp": nil,
        "flags": 0,
        "referenced_message": nil
    }
      WebMock.stub_request(:post, "https://discordapp.com/api/v6/channels/764050415054356482/messages").
        with(
            body: "{\"content\":\"**#{name}** hat sein Discord mit der blank_app verbunden\",\"tts\":false,\"embed\":null,\"nonce\":null}",
            headers: {
                'Accept'=>'*/*',
                'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Authorization'=>"#{ENV['bot_token']}",
                'Content-Length'=>/.*/,
                'Content-Type'=>'application/json',
                'Host'=>'discordapp.com',
                'User-Agent'=>'DiscordBot (https://github.com/meew0/discordrb, v3.3.0) rest-client/2.1.0 ruby/2.7.1p83 discordrb/3.3.0'
            }).
        to_return(status: 200, body: res_body.to_json, headers: {})
    end
    
  end

  def stub_channel
    body = {
        "id": "764050415054356482",
        "last_message_id": "768195988288307272",
        "last_pin_timestamp": "2020-10-09T09:06:41.079000+00:00",
        "type": 0,
        "name": "chat",
        "position": 0,
        "parent_id": "764050415054356480",
        "topic": nil,
        "guild_id": server_id,
        "permission_overwrites": [],
        "nsfw": false,
        "rate_limit_per_user": 0
    }
    WebMock.stub_request(:get, "https://discordapp.com/api/v6/channels/764050415054356482").
        with(headers: DEFAULT_HEADERS).
        to_return(status: 200, body: body.to_json, headers: {})
  end

  def stub_guild
    body = {
        "id": server_id,
        "name": "blank_app",
        "icon": nil,
        "description": nil,
        "splash": nil,
        "discovery_splash": nil,
        "features": [],
        "emojis": [],
        "banner": nil,
        "owner_id": "25681874",
        "application_id": nil,
        "region": "europe",
        "afk_channel_id": nil,
        "afk_timeout": 300,
        "system_channel_id": "764050415054356482",
        "widget_enabled": false,
        "widget_channel_id": nil,
        "verification_level": 0,
        "roles": roles_hash,
        "default_message_notifications": 0,
        "mfa_level": 0,
        "explicit_content_filter": 0,
        "max_presences": nil,
        "max_members": 100000,
        "max_video_channel_users": 25,
        "vanity_url_code": nil,
        "premium_tier": 0,
        "premium_subscription_count": 0,
        "system_channel_flags": 0,
        "preferred_locale": "en-US",
        "rules_channel_id": nil,
        "public_updates_channel_id": nil,
        "embed_enabled": false,
        "embed_channel_id": nil
    }

    WebMock.stub_request(:get, "https://discordapp.com/api/v6/guilds/#{server_id}").
        with(headers: DEFAULT_HEADERS).
        to_return(status: 200, body: body.to_json, headers: {})
  end

  def stub_member
    members_hash.each do |m|
      body = m
      WebMock.stub_request(:get, "https://discordapp.com/api/v6/guilds/#{server_id}/members/#{m[:user][:id]}").
          with(headers: DEFAULT_HEADERS).
          to_return(status: 200, body: body.to_json, headers: {})
    end
  end

  def stub_bot
    body = {
        "user": {
            "id": "764062582310436875",
            "username": "blank_web_app",
            "avatar": "09a169df66abf738561db2a57db082a4",
            "discriminator": "4986",
            "public_flags": 0,
            "bot": true
        },
        "roles": role_ids,
        "nick": nil,
        "premium_since": nil,
        "joined_at": "2020-10-09T10:00:33.168000+00:00",
        "is_pending": false,
        "mute": false,
        "deaf": false
    }
    WebMock.stub_request(:get, "https://discordapp.com/api/v6/guilds/#{server_id}/members/764062582310436875").
        with(headers: DEFAULT_HEADERS).
        to_return(status: 200, body: body.to_json, headers: {})
  end
end