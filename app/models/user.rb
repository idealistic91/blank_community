class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :member, dependent: :destroy

  after_create :create_member

  validate :discord_id_check
  validates :discord_id, uniqueness: true
  validates :discord_id, presence: true

  
  def self.find_by_discord_id(id)
    find_by(discord_id: id)
  end
  
  def create_member
    m = Member.new()
    m.user = self
    m.save
  end

  def do_i_participate?(event)
    event.members.include?(self.member)
  end

  def am_i_hosting?(event)
    event.hosts.include?(self.member) 
  end

  def discord_id_check
    if discord_id.empty?
      errors.add(:discord_id, "Keine discord id angegeben! Tippe 'register:me' in den Chat um einen Link zu erhalten")
    else
      unless Discord::Server.member_by(discord_id.to_i)
        errors.add(:discord_id, "Du bist kein Mitglied des Discord Servers!")
      end
    end
  end
end
