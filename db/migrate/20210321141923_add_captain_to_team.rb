class AddCaptainToTeam < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :captain_id, :integer
  end
end
