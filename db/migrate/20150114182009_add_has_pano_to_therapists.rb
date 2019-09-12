class AddHasPanoToTherapists < ActiveRecord::Migration
  def change
    add_column :therapists, :has_pano, :boolean
  end
end
