class Community < ApplicationRecord
    has_and_belongs_to_many :users
    has_many :members
    has_many :discord_roles
    has_many :events
    belongs_to :creator, class_name: 'User', foreign_key: :owner_id

    validates_presence_of :creator

    def get_discord_roles
        
    end
end