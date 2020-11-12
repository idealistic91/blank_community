class CreateTableDiscordRole < ActiveRecord::Migration[6.0]
  def change
    create_table :discord_roles do |t|
      t.string :name
      t.string :discord_id
      t.references :communities
      t.timestamps
    end
  end
end
