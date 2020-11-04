class AddCommunityReferenceToMembersTable < ActiveRecord::Migration[6.0]
  def change
    add_reference :members, :community, index: true, foreign_key: true
  end
end
