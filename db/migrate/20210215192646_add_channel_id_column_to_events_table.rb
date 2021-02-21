class AddChannelIdColumnToEventsTable < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :channel_id, :string
  end
end
