class RemoveStartAndEndTimeFromEvents < ActiveRecord::Migration[6.0]
  def change
    remove_column :events, :start_at, :datetime
    remove_column :events, :ends_at, :datetime
  end
end
