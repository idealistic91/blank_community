class RoleAssignment < ApplicationRecord
  belongs_to :discord_role
  belongs_to :role
end