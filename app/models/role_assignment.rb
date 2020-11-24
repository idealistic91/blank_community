class RoleAssigment < ApplicationRecord
  belongs_to :discord_role
  belongs_to :role
end