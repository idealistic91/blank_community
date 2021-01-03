class CreateSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :settings do |t|
      t.string :main_channel
      t.boolean :public, default: true
      t.belongs_to :community
    end
  end
end
