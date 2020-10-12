class Member < ApplicationRecord
  belongs_to :user
  has_many :hosts, through: :hosts, dependent: :destroy
  has_many :participants
  has_many :events, through: :participants
  has_one_attached :picture

  after_create :set_defaults

  def hosts
    Event.where(creator_id: id)
  end

  def set_defaults
    nickname = 'Nicht vorhanden'
    name = 'Nicht vorhanden'
    self.save
  end

  def nickname_is_set?
    return false if nickname.nil?
    nickname != 'Nicht vorhanden'
  end

  def has_picture?
    picture.attached?
  end
end
