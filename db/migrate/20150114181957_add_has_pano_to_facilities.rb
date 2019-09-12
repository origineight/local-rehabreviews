class AddHasPanoToFacilities < ActiveRecord::Migration
  def change
    add_column :facilities, :has_pano, :boolean
  end
end
