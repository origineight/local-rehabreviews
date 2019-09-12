class AddNewCityAndNewStateAbbreviationFieldsToListings < ActiveRecord::Migration
  def change
    add_column :listings, :new_city, :string
    add_column :listings, :new_state_abbreviation, :string
  end
end
