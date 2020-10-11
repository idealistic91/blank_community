class ChangeColumnViewUuidFroomRafflesTable < ActiveRecord::Migration[6.0]
  def change
    change_column :raffles, :view_uuid, :string, default: nil
  end
end
