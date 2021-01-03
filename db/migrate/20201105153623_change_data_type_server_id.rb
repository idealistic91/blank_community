class ChangeDataTypeServerId < ActiveRecord::Migration[6.0]
  def change
    change_column :communities, :server_id, :string
  end
end
