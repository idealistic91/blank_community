class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable

  has_many :communities, foreign_key: :owner_id
  has_many :memberships, class_name: 'Member', foreign_key: :user_id, dependent: :destroy
  has_one_attached :picture

  validate :discord_id_check
  validates :discord_id, uniqueness: true
  validates :discord_id, presence: true

  after_create :create_memberships
  before_save :ensure_authentication_token

  scope :membership_by_community, ->(id) { memberships.by_community(id) }
  scope :memberships, -> { memberships.by_user_id(id) }
  
  def self.find_by_discord_id(id)
    find_by(discord_id: id)
  end
  
  def do_i_participate?(event)
    event.members.include?(membership_by_community(event.community_id).first)
  end

  def am_i_hosting?(event)
    event.hosts.include?(membership_by_community(event.community_id).first) 
  end

  def has_picture?
    picture.attached?
  end

  def membership_by_community(id)
    self.memberships.by_community(id)
  end

  def create_membership(community)
    dc_user = community.server.get_member_by_id(discord_id)
    if dc_user
      membership = Member.new(user_id: id, community_id: community.id)
      if membership.save
        self.memberships << membership
        { success: true }
      else
        { success: false, message: membership.errors.full_messages.join(', ') }
      end
    else
      { success: false, message: "Du scheinst kein Mitglied auf dem #{community.name} Server zu sein!" }
    end
  end

  def ensure_authentication_token
    self.authentication_token ||= generate_authentication_token
  end

  def reset_authentication_token
    token = generate_authentication_token
    update(authentication_token: token)
  end

  private 

  def discord_id_check
    if discord_id.empty?
      errors.add(:discord_id, "Keine discord id angegeben! Tippe 'register:me' in den Chat um einen Link zu erhalten")
    end
  end

  def create_memberships
    Community.all.each do |c|
      create_membership(c)
    end
  end

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end
