class RemoveCommunitiesFromDiscordRoles < ActiveRecord::Migration[6.0]
  def change
    remove_reference :discord_roles, :communities
    add_reference :discord_roles, :community, foreign_key: true
  end
end
