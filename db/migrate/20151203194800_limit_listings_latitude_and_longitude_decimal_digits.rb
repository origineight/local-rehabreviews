class LimitListingsLatitudeAndLongitudeDecimalDigits < ActiveRecord::Migration
  def change
    change_column :listings, :latitude, :decimal, precision: 6, scale: 4
    change_column :listings, :longitude, :decimal, precision: 7, scale: 4
  end
end
