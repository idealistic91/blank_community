class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :member, dependent: :destroy

  after_create :create_member
  
  def create_member
    m = Member.new()
    if discord_id
      discord_data = Discord::Server.member_by(discord_id.to_i)
      m.nickname = discord_data.nil? ? 'Unknown' : discord_data['user']['username']
      if discord_data
        DISCORD_BOT.send_to_channel('chat', "**#{discord_data['user']['username']}** hat sein Discord mit der blank_app verbunden")
      end
    end
    m.user = self
    m.save
  end
end
