class DiscordRole < ApplicationRecord
    has_one :community
    belongs_to :role_assigment
end