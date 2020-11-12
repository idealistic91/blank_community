class Community < ApplicationRecord
    has_many :members, dependent: :destroy
    has_many :discord_roles, dependent: :destroy
    has_many :events, dependent: :destroy
    belongs_to :creator, class_name: 'User', foreign_key: :owner_id

    validates_presence_of :server_id
    validates_uniqueness_of :server_id
    
    after_create :create_discord_roles, :create_owner_member

    def server
        Discord::Server.new(id: server_id)
    end

    private 
    
    def create_discord_roles
        server.roles.each do |role|
            DiscordRole.create(name: role["name"],
                discord_id: role["id"],
                community_id: id
            )
        end
    end

    def create_owner_member
        if creator
            creator.memberships << Member.create_for_owner(self)
        end
    end
end