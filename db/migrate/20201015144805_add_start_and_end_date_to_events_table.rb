class AddStartAndEndDateToEventsTable < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :start_at, :datetime
    add_column :events, :ends_at, :datetime
  end
end
