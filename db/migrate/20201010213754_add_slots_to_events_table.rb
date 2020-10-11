class AddSlotsToEventsTable < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :slots, :integer
  end
end
