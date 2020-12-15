class RoleAssignment < ApplicationRecord
  belongs_to :discord_role
  belongs_to :role

  validate :role_combination

  private

  def combination_exists?
    RoleAssignment.find_by(discord_role_id: discord_role_id, role_id: role_id) ? true : false
  end

  def role_combination
    errors.add(:base, "Already exists") if combination_exists?
  end
end