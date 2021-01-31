class AddIgdbIdToGameModel < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :igdb_id, :string
    remove_column :events, :game_id
  end
end
