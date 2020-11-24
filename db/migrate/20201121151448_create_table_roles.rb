class CreateTableRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :roles do |t|
      t.string :key
    end
  end
end
