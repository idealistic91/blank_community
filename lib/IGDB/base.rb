module IGDB
    class Base
        require 'apicalypse'
        
        TOKEN_URL = 'https://id.twitch.tv/oauth2/token'
        CLIENT_ID = ENV['IGDB_CLIENT_ID']
        CLIENT_SECRET = ENV['IGDB_CLIENT_SECRET']
        DEFAULT_HEADERS = { 'Client-ID' => "#{CLIENT_ID}", 'Accept' => 'application/json' }


        CONFIG = YAML.load_file("#{Rails.root}/lib/IGDB/config.yml")
        BASE_URL = CONFIG['endpoints']['base']
        DOMAIN = CONFIG['endpoints']['domain']

        attr_accessor :success, :errors, :response, :token, :headers
        
        def initialize
            @success = true
            @errors = []
            @token = generate_token
            @headers = set_headers
        end

        def search_game(string, fields: [:name])
            request = Net::HTTP::Post.new(URI("#{BASE_URL}games"), headers)
            body = 'fields ' + fields.join(',') + ';search "' + string + '";'
            request.body = body
            response = set_http.request(request)
            JSON.parse(response.body)
        end

        def games(limit = 10)
            request = Net::HTTP::Post.new(URI("#{BASE_URL}games"), headers)
            request.body = "fields name; limit #{limit};"
            response = set_http.request(request)
            JSON.parse(response.body)
        end
        
        private

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

        def set_http
            http = Net::HTTP.new(DOMAIN, 443)
            http.use_ssl = true
            http
        end

        def set_headers
            DEFAULT_HEADERS['Authorization'] = "Bearer #{token}" unless token.nil?
            DEFAULT_HEADERS
        end
    end
end