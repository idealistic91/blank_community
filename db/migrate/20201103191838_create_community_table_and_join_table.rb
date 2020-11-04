class CreateCommunityTableAndJoinTable < ActiveRecord::Migration[6.0]
  def change
    create_table :communities do |t|
      t.string :name
      t.text :description
      t.integer :owner_id
      t.integer :server_id
      t.timestamps
    end

    create_table :communities_users, id: false do |t|
      t.belongs_to :community
      t.belongs_to :user
    end
  end
end
