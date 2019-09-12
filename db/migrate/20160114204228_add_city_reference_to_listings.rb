class AddCityReferenceToListings < ActiveRecord::Migration
  def change
    add_column :listings, :city_id, :integer, references: :city
    rename_column :listings, :city, :old_city
  end
end
