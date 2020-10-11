class AddColumViewUuidToRafflesTable < ActiveRecord::Migration[6.0]
  def change
    add_column :raffles, :view_uuid, :integer, default: nil
  end
end
