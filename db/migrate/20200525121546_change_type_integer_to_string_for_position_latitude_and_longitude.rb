class ChangeTypeIntegerToStringForPositionLatitudeAndLongitude < ActiveRecord::Migration[6.0]
  def change
    change_column :positions, :longitude, :string
    change_column :positions, :latitude, :string
  end
end
