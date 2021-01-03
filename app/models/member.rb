class Member < ApplicationRecord
  belongs_to :user
  belongs_to :community
  has_many :participants, dependent: :destroy
  has_many :hosting_events, dependent: :destroy
  has_many :events, through: :hosting_events
  has_many :events, through: :participants
  has_many :member_discord_roles, dependent: :destroy
  has_many :discord_roles, through: :member_discord_roles
  
  validates_presence_of :user
  validates_presence_of :community_id
  validates_uniqueness_of :user, scope: :community_id
  validate :user_present_on_server
  validate :has_right_to_join?

  after_create :set_defaults

  scope :by_community, ->(community_id) { where(community_id: community_id) }
  scope :by_user_id, ->(id) { where(user_id: id) }

  def self.create_for_owner(community)
    create(user_id: community.creator.id, community_id: community.id)
  end

  def discord_user
    if user.discord_id
      data = community.server.get_member_by_id(user.discord_id)
      Discordrb::User.new(data['user'], DISCORD_BOT.bot)
    end
  end

  def server_roles
    community.server.get_member_by_id(user.discord_id)["roles"]
  end

  def roles
    if discord_roles.any?
      discord_roles.map(&:roles).flatten.uniq
    else
      nil
    end
  end

  def discord_avatar
    discord_user.avatar_url('png')
  end

  def update_picture
    user.picture.detach
    user.picture.purge_later
    set_picture(discord_avatar)
  end

  def owner?
    self.community.owner_id == self.user.id
  end

  def has_role?(key)
    roles.include?(Role.send("#{key}_role"))
  end

  def assign_roles
    # Todo: Needs logic to update roles from discord server
    dc_roles = community.discord_roles.where(discord_id: server_roles)
    dc_roles.each do |dc_role|
      unless discord_roles.include?(dc_role)
        self.member_discord_roles << MemberDiscordRole.create(discord_role: dc_role, member: self)
      end
    end
    if owner?
      self.member_discord_roles <<
          MemberDiscordRole.create(discord_role: DiscordRole.find_by(name: 'Owner'), member: self)
    end
  end

  def has_right_to_join?
    rights_via_server_roles = community.discord_roles
                                  .where(discord_id: server_roles)
                                  .map(&:roles).flatten.uniq.map(&:key)
    has_right = %w(member admin owner).detect{|key| rights_via_server_roles.include?(key) }
    unless has_right || owner?
      errors.add(:base, "Dir fehlen Rechte um der Community beizutreten. Folgende Server-Rollen berechtigen dich zum Beitritt: #{community.joinable_dc_roles.join(', ')}")
    end
  end

  private

  def set_defaults
    if user.discord_id
      dc_user = discord_user
      self.nickname = dc_user.username
      set_picture(dc_user.avatar_url('png'))
      bot = Discord::Bot.new(id: community.server_id)
      # Todo: Send to main channel set in the community settings
      assign_roles
      Thread.new do
        channel = community.get_main_channel
        bot.send_to_channel(channel[:name], "**#{nickname}** ist der #{community.name}-community beigetreten") if channel
      end
      self.save
    end
  end

  def set_picture(url)
    unless user.has_picture?
      image = Net::HTTP.get(URI.parse(url))
      file = Tempfile.new("#{self.nickname}.png")
      file.binmode
      file.write(image)
      file.flush
      user.picture.attach(io: File.open(file.path), filename: "#{self.nickname.gsub('.', '_')}.png", content_type: "image/png")
      file.unlink
    end
  end

  def user_present_on_server
    unless community.server.get_member_by_id(user.discord_id)
      errors.add(:base, "User nicht Teil der #{community.name}-community!")
    end
  end
end
