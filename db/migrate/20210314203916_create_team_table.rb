class CreateTeamTable < ActiveRecord::Migration[6.1]
  def change
    create_table :teams do |t|
      t.string :name
      t.integer :slots
      t.belongs_to :event
      t.timestamps
    end
  end
end
