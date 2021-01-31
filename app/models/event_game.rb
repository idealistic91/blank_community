class EventGame < ApplicationRecord
    belongs_to :game
    belongs_to :event

    validates :game, :event, presence: true
    validate :unique_combination

    def unique_combination
        errors.add(:base, 'Spiel und Event müssen unique sein!') if EventGame.where(game: game, event: event).any?
    end
end
