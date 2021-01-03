class CreateRolesTable < ActiveRecord::Migration[6.0]
  def change
    create_table :roles_tables do |t|
      t.string :name
    end
  end
end
