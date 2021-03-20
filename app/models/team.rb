class Team < ApplicationRecord
    belongs_to :event
    has_many :participants

    def join_team(participant)
        participants << participant
    end
end