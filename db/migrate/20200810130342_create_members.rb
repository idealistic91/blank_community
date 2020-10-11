class CreateMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :members do |t|
      t.timestamps
      t.string :name
      t.string :nickname
      t.references :user
    end
  end
end
