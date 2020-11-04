def stub_all_members(discord_id)
    body = [
        {
            "user": {
                "id": "#{discord_id}",
                "username": "Idealistic",
                "avatar": "e9ae27c22e64a23eb4693a0fd6ea887c",
                "discriminator": "5802",
                "public_flags": 0
            },
            "roles": [
                "764604592833953792"
            ],
            "nick": nil,
            "premium_since": nil,
            "joined_at": "2020-10-09T10:28:09.507000+00:00",
            "is_pending": false,
            "mute": false,
            "deaf": false
        },
        {
            "user": {
                "id": "85734785",
                "username": "Gamer2020",
                "avatar": "e9ae27c22e64a23eb4693a0fd6ea887c",
                "discriminator": "5802",
                "public_flags": 0
            },
            "roles": [
                "764604592833953792"
            ],
            "nick": nil,
            "premium_since": nil,
            "joined_at": "2020-10-09T10:28:09.507000+00:00",
            "is_pending": false,
            "mute": false,
            "deaf": false
        }
    ]
    stub_request(:get, "https://discordapp.com/api/v6/guilds/764050414542389251/members?limit=100")
            .with(
                headers: {
                'Accept'=>'*/*',
                'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Authorization'=>"#{ENV['bot_token']}",
                'Host'=>'discordapp.com',
                'User-Agent'=>'DiscordBot (https://github.com/meew0/discordrb, v3.3.0) rest-client/2.1.0 ruby/2.7.1p83 discordrb/3.3.0'
                })
            .to_return(status: 200, body: body.to_json, headers: {})      

end

def stub_roles
    body = [
        {
            "id": "764604592833953792",
            "name": "@everyone",
            "permissions": "104320577",
            "position": 0,
            "color": 0,
            "hoist": false,
            "managed": false,
            "mentionable": false
        }
    ]
    stub_request(:get, "https://discordapp.com/api/v6/guilds/764050414542389251/roles")
        .with(
        headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Authorization'=>"#{ENV['bot_token']}",
        'Host'=>'discordapp.com',
        'User-Agent'=>'DiscordBot (https://github.com/meew0/discordrb, v3.3.0) rest-client/2.1.0 ruby/2.7.1p83 discordrb/3.3.0'
        })
        .to_return(status: 200, body: body.to_json, headers: {})
end

def stub_avatar_request
    stub_request(:get, "https://cdn.discordapp.com/avatars/25681874/e9ae27c22e64a23eb4693a0fd6ea887c.png").
         with(
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Host'=>'cdn.discordapp.com',
          'User-Agent'=>'Ruby'
           }).
         to_return(status: 200, body: File.read('spec/support/images/avatar.png'), headers: {})
end

def stub_channels
  body = [{"id"=>"764050415054356480", "type"=>4, "name"=>"Textkanäle", "position"=>0, "parent_id"=>nil, "guild_id"=>"764050414542389251", "permission_overwrites"=>[], "nsfw"=>false}, {"id"=>"764050415054356481", "type"=>4, "name"=>"Sprachkanäle", "position"=>0, "parent_id"=>nil, "guild_id"=>"764050414542389251", "permission_overwrites"=>[], "nsfw"=>false}, {"id"=>"764050415054356482", "last_message_id"=>"768126051330162718", "last_pin_timestamp"=>"2020-10-09T09:06:41.079000+00:00", "type"=>0, "name"=>"chat", "position"=>0, "parent_id"=>"764050415054356480", "topic"=>nil, "guild_id"=>"764050414542389251", "permission_overwrites"=>[], "nsfw"=>false, "rate_limit_per_user"=>0}, {"id"=>"764050415054356483", "type"=>2, "name"=>"Allgemein", "position"=>0, "parent_id"=>"764050415054356481", "bitrate"=>64000, "user_limit"=>0, "guild_id"=>"764050414542389251", "permission_overwrites"=>[], "nsfw"=>false}, {"id"=>"764050558990286848", "last_message_id"=>"764051530751016971", "last_pin_timestamp"=>"2020-10-09T09:08:00.292000+00:00", "type"=>0, "name"=>"events", "position"=>1, "parent_id"=>"764050415054356480", "topic"=>nil, "guild_id"=>"764050414542389251", "permission_overwrites"=>[], "nsfw"=>false, "rate_limit_per_user"=>0}, {"id"=>"766735147994710058", "last_message_id"=>"766736479074385960", "type"=>0, "name"=>"app_errors", "position"=>2, "parent_id"=>"764050415054356480", "topic"=>nil, "guild_id"=>"764050414542389251", "permission_overwrites"=>[], "nsfw"=>false, "rate_limit_per_user"=>0}]
  stub_request(:get, "https://discordapp.com/api/v6/guilds/764050414542389251/channels").
      with(
          headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Authorization'=>"#{ENV['bot_token']}",
              'Host'=>'discordapp.com',
              'User-Agent'=>'DiscordBot (https://github.com/meew0/discordrb, v3.3.0) rest-client/2.1.0 ruby/2.7.1p83 discordrb/3.3.0'
          }).
      to_return(status: 200, body: body.to_json, headers: {})
end

def stub_send_message
  res_body = {
      "id": "768195988288307272",
      "type": 0,
      "content": "**Idealistic** hat sein Discord mit der blank_app verbunden",
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
  stub_request(:post, "https://discordapp.com/api/v6/channels/764050415054356482/messages").
      with(
          body: "{\"content\":\"**Idealistic** hat sein Discord mit der blank_app verbunden\",\"tts\":false,\"embed\":null,\"nonce\":null}",
          headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Authorization'=>"#{ENV['bot_token']}",
              'Content-Length'=>'111',
              'Content-Type'=>'application/json',
              'Host'=>'discordapp.com',
              'User-Agent'=>'DiscordBot (https://github.com/meew0/discordrb, v3.3.0) rest-client/2.1.0 ruby/2.7.1p83 discordrb/3.3.0'
          }).
      to_return(status: 200, body: res_body.to_json, headers: {})
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
      "guild_id": "764050414542389251",
      "permission_overwrites": [],
      "nsfw": false,
      "rate_limit_per_user": 0
  }
  stub_request(:get, "https://discordapp.com/api/v6/channels/764050415054356482").
      with(
          headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Authorization'=>"#{ENV['bot_token']}",
              'Host'=>'discordapp.com',
              'User-Agent'=>'DiscordBot (https://github.com/meew0/discordrb, v3.3.0) rest-client/2.1.0 ruby/2.7.1p83 discordrb/3.3.0'
          }).
      to_return(status: 200, body: body.to_json, headers: {})
end

def stub_guild
  body = {
      "id": "764050414542389251",
      "name": "blank_app",
      "icon": nil,
      "description": nil,
      "splash": nil,
      "discovery_splash": nil,
      "features": [],
      "emojis": [],
      "banner": nil,
      "owner_id": "267017148235382784",
      "application_id": nil,
      "region": "europe",
      "afk_channel_id": nil,
      "afk_timeout": 300,
      "system_channel_id": "764050415054356482",
      "widget_enabled": false,
      "widget_channel_id": nil,
      "verification_level": 0,
      "roles": [
          {
              "id": "764050414542389251",
              "name": "@everyone",
              "permissions": 104320577,
              "position": 0,
              "color": 0,
              "hoist": false,
              "managed": false,
              "mentionable": false,
              "permissions_new": "104320577"
          },
          {
              "id": "764064754494603295",
              "name": "blank_web_app",
              "permissions": 8,
              "position": 4,
              "color": 0,
              "hoist": false,
              "managed": true,
              "mentionable": false,
              "tags": {
                  "bot_id": "764062582310436875"
              },
              "permissions_new": "8"
          },
          {
              "id": "764604592833953792",
              "name": "admin",
              "permissions": 104320587,
              "position": 3,
              "color": 11342935,
              "hoist": false,
              "managed": false,
              "mentionable": false,
              "permissions_new": "104320587"
          },
          {
              "id": "764605093244698624",
              "name": "friends",
              "permissions": 104320576,
              "position": 2,
              "color": 7419530,
              "hoist": false,
              "managed": false,
              "mentionable": false,
              "permissions_new": "104320576"
          },
          {
              "id": "764617770716889098",
              "name": "developer",
              "permissions": 104320577,
              "position": 1,
              "color": 15844367,
              "hoist": false,
              "managed": false,
              "mentionable": false,
              "permissions_new": "104320577"
          }
      ],
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
  stub_request(:get, "https://discordapp.com/api/v6/guilds/764050414542389251").
      with(
          headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Authorization'=>"#{ENV['bot_token']}",
              'Host'=>'discordapp.com',
              'User-Agent'=>'DiscordBot (https://github.com/meew0/discordrb, v3.3.0) rest-client/2.1.0 ruby/2.7.1p83 discordrb/3.3.0'
          }).
      to_return(status: 200, body: body.to_json, headers: {})
end

def stub_member
  body = {
      "user": {
          "id": "267017148235382784",
          "username": "idealistic",
          "avatar": "3f8f33b2ccfb2e867c78b993987fb5cf",
          "discriminator": "1847",
          "public_flags": 0
      },
      "roles": [
          "764617770716889098"
      ],
      "nick": nil,
      "premium_since": nil,
      "joined_at": "2020-10-09T09:03:34.295000+00:00",
      "is_pending": false,
      "mute": false,
      "deaf": false
  }
  stub_request(:get, "https://discordapp.com/api/v6/guilds/764050414542389251/members/267017148235382784").
      with(
          headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Authorization'=>"#{ENV['bot_token']}",
              'Host'=>'discordapp.com',
              'User-Agent'=>'DiscordBot (https://github.com/meew0/discordrb, v3.3.0) rest-client/2.1.0 ruby/2.7.1p83 discordrb/3.3.0'
          }).
      to_return(status: 200, body: body.to_json, headers: {})
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
      "roles": [
          "764064754494603295"
      ],
      "nick": nil,
      "premium_since": nil,
      "joined_at": "2020-10-09T10:00:33.168000+00:00",
      "is_pending": false,
      "mute": false,
      "deaf": false
  }
  stub_request(:get, "https://discordapp.com/api/v6/guilds/764050414542389251/members/764062582310436875").
      with(
          headers: {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Authorization'=>"#{ENV['bot_token']}",
              'Host'=>'discordapp.com',
              'User-Agent'=>'DiscordBot (https://github.com/meew0/discordrb, v3.3.0) rest-client/2.1.0 ruby/2.7.1p83 discordrb/3.3.0'
          }).
      to_return(status: 200, body: body.to_json, headers: {})
end