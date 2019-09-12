class AddCountryToListings < ActiveRecord::Migration
  def up
    add_column :listings, :country, :string, default: 'US'
  end
  
  def down
    remove_column :listings, :country, :string
  end
end
