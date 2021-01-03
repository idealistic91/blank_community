class CreateMemberDiscordRole < ActiveRecord::Migration[6.0]
  def change
    create_table :member_discord_roles do |t|
      t.belongs_to :member
      t.belongs_to :discord_role
      t.timestamps
    end
  end
end
