class CreateRoleAssignmentsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :role_assignments do |t|
      t.belongs_to :role
      t.belongs_to :discord_role
      t.timestamps
    end
  end
end
