class AddStateToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :state, :string
  end
end
