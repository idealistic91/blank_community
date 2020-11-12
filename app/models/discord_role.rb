class DiscordRole < ApplicationRecord
    has_one :community
    has_many :roles
end