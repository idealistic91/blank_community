class ChangeColumnTypeToCategory < ActiveRecord::Migration[6.0]
  def change
    rename_column :positions, :type, :category
  end
end
