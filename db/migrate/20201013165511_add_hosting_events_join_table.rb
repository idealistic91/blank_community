class AddHostingEventsJoinTable < ActiveRecord::Migration[6.0]
  def change
    create_table :hosting_events do |t|
      t.belongs_to :event
      t.belongs_to :member
      t.timestamps
    end
  end
end
