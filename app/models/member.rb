class Member < ApplicationRecord
  belongs_to :user
  has_many :participants
  has_many :hosting_events, dependent: :destroy
  has_many :events, through: :hosting_events
  has_many :events, through: :participants
  has_one_attached :picture

  after_create :set_defaults

  validates :nickname, uniqueness: true
  validates :user_id, uniqueness: { scope: :member_id }

  def set_defaults
    nickname = 'Nicht vorhanden'
    name = 'Nicht vorhanden'
    if user.discord_id
      dc_user = discord_user
      set_picture(dc_user.avatar_url('png'))
      nickname = dc_user.username
      DISCORD_BOT.send_to_channel('chat', "**#{nickname}** hat sein Discord mit der blank_app verbunden")
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
      temp = Tempfile.new('avatar.png')
      temp.write(image)
      temp.rewind
      temp.close
      picture.attach(io: File.open('temp.png'), filename: "#{nickname}.png", content_type: "image/png")
      temp.unlink
    end
  end
end
