class AddFacilityNameToListings < ActiveRecord::Migration
  def change
    add_column :listings, :facility_name, :string
  end
end
