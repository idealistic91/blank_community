class Participant < ApplicationRecord
    belongs_to :member
    belongs_to :event

    validates_uniqueness_of :event_id, :scope => :member_id
end