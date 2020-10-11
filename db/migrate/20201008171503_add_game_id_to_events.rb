class AddGameIdToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :game_id, :integer, index: true
  end
end
