class RenameLatitudeAndLongitudeForTherapists < ActiveRecord::Migration
  def change
    rename_column :therapists, :latitude, :legacy_latitude
    rename_column :therapists, :longitude, :legacy_longitude

    add_column :therapists, :latitude, :float
    add_column :therapists, :longitude, :float
  end
end
