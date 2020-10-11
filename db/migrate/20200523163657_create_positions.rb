class CreatePositions < ActiveRecord::Migration[6.0]
  def change
    create_table :positions do |t|
      t.integer :longitude
      t.integer :latitude
      t.text :name
      t.string :type

      t.timestamps
    end
  end
end
