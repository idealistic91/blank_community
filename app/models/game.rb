class Game < ApplicationRecord
    after_create_commit :convert_image
    has_many :events
    has_one_attached :title_picture
    has_one_attached :index_picture
    
    validates :title_picture, presence: true, blob: { content_type: ['image/jpg', 'image/jpeg', 'image/png'], size_range: 1..3.megabytes }

    def convert_image
        unless title_picture.blob.content_type == 'image/png'
           # ToDo: Refactor!
            temp = File.open('temp.jpg', 'wb') do |file| 
                file << title_picture.blob.download
            end
    
            new_image = Magick::Image.read('temp.jpg').first
            
            new_image.format = 'png'
            new_image = new_image.resize_to_fit('1100')
            new_image.background_color = "none"
            new_image.alpha(Magick::ActivateAlphaChannel)
            new_image.opacity = Magick::QuantumRange - (Magick::QuantumRange * 0.3)
 
            new_image.write("temp.png")
            # detach current picture & attach new one
            title_picture.detach
            title_picture.purge_later
            title_picture.attach(io: File.open("temp.png"), filename: "#{name.gsub(' ', '_').downcase}.png", content_type: "image/png")

            index_image = Magick::Image.read('temp.png').first
            index_image = index_image.resize_to_fit('600')
            index_image.background_color = "none"
            index_image.alpha(Magick::ActivateAlphaChannel)
            index_image.opacity = Magick::QuantumRange - (Magick::QuantumRange * 0.4)

            index_image.write("temp.png")
            index_picture.attach(io: File.open("temp.png"), filename: "index_#{name.gsub(' ', '_').downcase}.png", content_type: "image/png")
            # maybe delete temp files
            File.delete('temp.png')
            File.delete('temp.jpg')
            return
        end
    end
end
