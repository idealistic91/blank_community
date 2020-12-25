class Community < ApplicationRecord
    has_many :members, dependent: :destroy
    has_many :discord_roles, dependent: :destroy
    has_many :events, dependent: :destroy
    has_one :settings, dependent: :destroy
    accepts_nested_attributes_for :settings
    belongs_to :creator, class_name: 'User', foreign_key: :owner_id, optional: true

    validates_presence_of :server_id
    validates_uniqueness_of :server_id
    
    after_create :create_discord_roles, :create_owner_member, :create_settings

    scope :discord_roles_by_id, ->(role_ids) { discord_roles.where(discord_id: role_ids) }

    def server
        Discord::Server.new(id: server_id)
    end

    def text_channels
        begin
            response = server.text_channels
            response.map do |channel|
                { id: channel['id'], name: channel['name'] }
            end
        rescue => exception
            nil
        end
    end

    def get_main_channel
        begin
            text_channels.detect { |channel| channel[:id] == settings.main_channel }
        rescue => exception
            nil
        end
    end

    private 
    
    def create_discord_roles
        owner_role = DiscordRole.create(name: 'Owner', community_id: id)
        owner_role.assign_role(:owner)
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

    def create_settings
        self.settings = Settings.new
    end
end