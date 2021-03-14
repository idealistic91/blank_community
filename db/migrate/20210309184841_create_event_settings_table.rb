class CreateEventSettingsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :event_settings do |t|
      t.belongs_to :event, index: { unique: true }, foreign_key: true
      t.string :event_type, default: 'default'
      t.boolean :create_channel, default: false
      t.string :notify_participants, default: 'dont'
      t.boolean :remind_server, default: true
      t.boolean :restricted, default: false
      t.timestamps
    end
  end
end
