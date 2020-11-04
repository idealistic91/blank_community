class Member < ApplicationRecord
  belongs_to :user
  has_many :participants
  has_many :hosting_events, dependent: :destroy
  has_many :events, through: :hosting_events
  has_many :events, through: :participants
  has_one_attached :picture
  has_one :community

  after_create :set_defaults

  validates :user_id, uniqueness: true

  def set_defaults
    nickname = 'Nicht vorhanden'
    name = 'Nicht vorhanden'
    if user.discord_id
      dc_user = discord_user
      set_picture(dc_user.avatar_url('png'))
      self.nickname = dc_user.username
      DISCORD_BOT.send_to_channel('chat', "**#{self.nickname}** hat sein Discord mit der blank_app verbunden")
    end
    self.save
  end

  def nickname_is_set?
    return false if nickname.nil?
    nickname != 'Nicht vorhanden'
  end

  def discord_user
    if user.discord_id
      data = Discord::Server.member_by(user.discord_id.to_i)
      Discordrb::User.new(data['user'], DISCORD_BOT.bot)
    end
  end

  def has_picture?
    picture.attached?
  end

  def discord_avatar
    discord_user.avatar_url('png')
  end

  def host_name_info
    nickname_is_set? ? nickname : user.email
  end

  def update_picture
    picture.detach
    picture.purge_later
    set_picture(discord_user.avatar_url)
  end
  
  private
  
  def set_picture(url)
    unless has_picture?
      image = Net::HTTP.get(URI.parse(url))
      file = Tempfile.open('avatar.png') do |f|
        f.binmode
        f.write(image)
        f.flush
      end
      picture.attach(io: File.open(file.path), filename: "#{nickname}.png", content_type: "image/png")
    end
  end
end
