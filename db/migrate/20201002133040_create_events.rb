class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :title
      t.date :date
      t.datetime :start_at
      t.datetime :ends_at
      t.text :description

      t.timestamps
    end
  end
end
