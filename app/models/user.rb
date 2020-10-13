class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :member, dependent: :destroy

  after_create :create_member
  
  def create_member
    m = Member.new()
    m.user = self
    m.save
  end
end
