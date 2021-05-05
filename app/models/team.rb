class Team < ApplicationRecord
    belongs_to :event
    belongs_to :captain, class_name: 'Participant', optional: true
    has_many :participants

    def join_team(participant)
        participants << participant
    end

    def assign_captain(participant)
        self.captain = participant
        self.save
    end

    def unassign_captain
        self.captain = nil
        self.save
    end
end