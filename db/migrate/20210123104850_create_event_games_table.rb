class CreateEventGamesTable < ActiveRecord::Migration[6.0]
  def change
    create_table :event_games do |t|
      t.belongs_to :game
      t.belongs_to :event
      t.timestamps
    end
  end
end
