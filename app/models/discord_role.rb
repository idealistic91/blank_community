class DiscordRole < ApplicationRecord
    has_one :community
    has_many :role_assignments, dependent: :destroy
    has_many :roles, through: :role_assignments

    def assign_role(key)
        self.role_assignments << RoleAssignment.create(discord_role: self, role: Role.send("#{key}_role"))
    end
end