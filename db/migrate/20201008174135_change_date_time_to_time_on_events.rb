class ChangeDateTimeToTimeOnEvents < ActiveRecord::Migration[6.0]
  def change
    change_column :events, :start_at, :time
    change_column :events, :ends_at, :time
  end
end
