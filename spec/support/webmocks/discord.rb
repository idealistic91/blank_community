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
        }
    ]
    stub_request(:get, "https://discordapp.com/api/v6/guilds/764050414542389251/members?limit=100")
            .with(
                headers: {
                'Accept'=>'*/*',
                'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Authorization'=>'Bot NzY0MDYyNTgyMzEwNDM2ODc1.X4Ayuw.-PAN2IjYxFE0Zyqr2KIqyC9b6Rg',
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
        'Authorization'=>'Bot NzY0MDYyNTgyMzEwNDM2ODc1.X4Ayuw.-PAN2IjYxFE0Zyqr2KIqyC9b6Rg',
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