module IGDB
    class Base
        TOKEN_URL = 'https://id.twitch.tv/oauth2/token'
        CLIENT_ID = ENV['IGDB_CLIENT_ID']
        CLIENT_SECRET = ENV['IGDB_CLIENT_SECRET']
        DEFAULT_HEADERS = { 'Client-ID' => "#{CLIENT_ID}", 'Accept' => 'application/json' }
        CONFIG = YAML.load_file("#{Rails.root}/lib/IGDB/config.yml")
        BASE_URL = CONFIG['endpoints']['base']
        GAMES_URL = "#{CONFIG['endpoints']['base']}#{CONFIG['endpoints']['games']}"
        DOMAIN = CONFIG['endpoints']['domain']

        attr_accessor :success, :errors, :response, :token, :headers, :request
        
        def initialize
            @success = true
            @errors = []
            @token = generate_token
            @headers = set_headers
            @request = nil
            @response = nil
        end

        def search_game(string, fields: [:name])
            @request = Net::HTTP::Post.new(URI("#{GAMES_URL}"), headers)

            request.body = 'fields ' + fields.join(',') + ';search "' + string + '";'
            request_and_parse
        end

        def games(limit = 10, fields: [:name])
            @request = Net::HTTP::Post.new(URI("#{GAMES_URL}"), headers)
            request.body = "fields #{fields.join(',')}; limit #{limit};"
            request_and_parse
        end

        def game(id, fields: [:name])
            @request = Net::HTTP::Post.new(URI("#{GAMES_URL}"), headers)
            request.body = "where id = #{id};fields #{fields.join(',')};"
            request_and_parse
        end

        protected

        def generate_token
            params = "client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&grant_type=client_credentials"
            response = Net::HTTP.post(URI.parse(TOKEN_URL), params)
            if response.class == Net::HTTPOK
                JSON.parse(response.body)['access_token']
            else
                @success = false
                @errors << 'Token could not be set'
                nil
            end
        end

        def no_rights?
            if request.class == Net::HTTPForbidden
                generate_token
            end
        end
        
        def game(id, fields: [:name])
            @request = Net::HTTP::Post.new(URI("#{GAMES_URL}"), headers)
            request.body = "where id = #{id};fields #{fields.join(',')};"
            request_and_parse
        end

        def set_http
            http = Net::HTTP.new(DOMAIN, 443)
            http.use_ssl = true
            http
        end

        def request_and_parse
            begin
                @response = set_http.request(request)
                if no_rights?
                    generate_token
                    set_headers
                    @response = set_http.request(request)
                end
                JSON.parse(response.body)
            rescue => exception
                success = false
                raise exception
            end
        end

        def set_headers
            DEFAULT_HEADERS['Authorization'] = "Bearer #{token}" unless token.nil?
            DEFAULT_HEADERS
        end
    end
end