class Position < ApplicationRecord
  validates_presence_of :latitude, :longitude, :category
end
