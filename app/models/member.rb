class Member < ApplicationRecord
  belongs_to :user
  has_many :participants, dependent: :destroy
  has_many :hosting_events, dependent: :destroy
  has_many :events, through: :hosting_events
  has_many :events, through: :participants
  belongs_to :community

  validates_presence_of :user
  validates_presence_of :community_id
  validate :user_present_on_server

  after_create :set_defaults

  scope :by_community, ->(community_id) { where(community_id: community_id) }
  scope :by_user_id, ->(id) { where(user_id: id) }

  def set_defaults
    name = 'Nicht vorhanden'
    if user.discord_id
      dc_user = discord_user
      self.nickname = dc_user.username
      set_picture(dc_user.avatar_url('png'))
      bot = Discord::Bot.new(id: community.server_id)
      # Todo: Send to main channel set in the community settings
      bot.send_to_channel('chat', "**#{nickname}** hat sein Discord mit der blank_app verbunden")
    end
    self.save
  end

  def nickname_is_set?
    return false if nickname.nil?
    nickname != 'Nicht vorhanden'
  end

  def self.create_for_owner(community)
    create(user_id: community.creator.id, community_id: community.id)
  end

  def discord_user
    if user.discord_id
      data = community.server.member_by(user.discord_id.to_i)
      Discordrb::User.new(data['user'], DISCORD_BOT.bot)
    end
  end

  def discord_avatar
    discord_user.avatar_url('png')
  end

  def host_name_info
    nickname_is_set? ? nickname : user.email
  end

  def update_picture
    user.picture.detach
    user.picture.purge_later
    set_picture(discord_avatar)
  end

  private
  
  def set_picture(url)
    unless user.has_picture?
      image = Net::HTTP.get(URI.parse(url))
      file = Tempfile.new('avatar.png')
      file.binmode
      file.write(image)
      file.flush
      user.picture.attach(io: File.open(file.path), filename: "#{self.nickname.gsub('.', '_')}.png", content_type: "image/png")
      file.unlink
    end
  end

  def user_present_on_server
    unless community.server.member_by(user.discord_id.to_i)
      errors.add(:base, "User nicht Teil der #{community.name}-community!")
    end
  end
end
