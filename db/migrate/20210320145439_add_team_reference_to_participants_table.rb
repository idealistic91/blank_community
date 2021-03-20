class AddTeamReferenceToParticipantsTable < ActiveRecord::Migration[6.1]
  def change
    add_reference :participants, :team, foreign_key: true
  end
end
