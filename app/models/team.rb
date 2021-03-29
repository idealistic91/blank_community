class Team < ApplicationRecord
    belongs_to :event
    has_one :captain, class_name: 'Participant'
    has_many :participants

    def join_team(participant)
        participants << participant
    end

    def assign_captain(participant)
        self.captain = participant
        self.save
    end
end