class MemberDiscordRole < ApplicationRecord
    belongs_to :member
    belongs_to :discord_role
end