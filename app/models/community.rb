class Community < ApplicationRecord
    has_many :members, dependent: :destroy
    has_many :discord_roles, dependent: :destroy
    has_many :events, dependent: :destroy
    has_one :settings, dependent: :destroy
    has_one_attached :picture
    accepts_nested_attributes_for :settings
    belongs_to :creator, class_name: 'User', foreign_key: :owner_id, optional: true

    validates_presence_of :server_id
    validates_uniqueness_of :server_id
    
    after_create :create_discord_roles, :create_owner_member, :create_settings, :set_picture

    scope :discord_roles_by_id, ->(role_ids) { discord_roles.where(discord_id: role_ids) }

    def server
        Discord::Server.new(id: server_id, bot: DISCORD_BOT.bot)
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

    def add_picture
        set_picture
    end

    def joinable_dc_roles
        discord_roles.map(&:role_assignments)
            .flatten.select{|assignment| assignment.role.key == 'admin' || assignment.role.key == 'member' }
            .map{|assignment| assignment.discord_role.name }
    end

    private

    def set_picture
        unless picture.attached?
            base64 = server.download_icon
            file = Tempfile.new("#{self.name}.png")
            file.binmode
            file.write(base64)
            file.flush
            picture.attach(io: File.open(file.path), filename: "#{self.name.gsub('.', '_')}.png", content_type: "image/png")
            file.unlink
        end
    end

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