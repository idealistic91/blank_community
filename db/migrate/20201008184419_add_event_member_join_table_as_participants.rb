class AddEventMemberJoinTableAsParticipants < ActiveRecord::Migration[6.0]
  def change
    create_table :participants do |t|
      t.belongs_to :event
      t.belongs_to :member
      t.timestamps
    end
  end
end
