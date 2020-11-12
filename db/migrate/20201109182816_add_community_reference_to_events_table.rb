class AddCommunityReferenceToEventsTable < ActiveRecord::Migration[6.0]
  def change
    add_reference :events, :community, foreign_key: true
  end
end
