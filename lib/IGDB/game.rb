module IGDB
    class Game < Base

        DEFAULT_FIELDS = ['name', 'cover.url']
        IMAGE_SIZES = ['cover_small', 'thumb', 'screenshot_med', 'cover_big', 'logo_med', 'screenshot_big', 'screenshot_huge', 'micro', '720p', '1080p']
        
        attr_accessor :id, :data, :name, :cover_url
        
        def initialize(id)
            data = api.game(id, fields: DEFAULT_FIELDS).first
            @data = data
            @id = data['id']
            @name = data['name']
            @cover_url = data['cover']['url']
        end

        def download_cover(size = 'thumb')
            return false unless IMAGE_SIZES.include?(size)
            self.cover_url = self.cover_url.gsub('thumb', size) if size != 'thumb'
            http = Net::HTTP.new('images.igdb.com', 443)
            http.use_ssl = true
            request = Net::HTTP::Get.new(URI("https:#{cover_url}"), headers)
            response = http.request(request)
            response.body
        end

        private

        def api
            Base.new
        end
    end
end