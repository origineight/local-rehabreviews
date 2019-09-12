class AddCustomAndLongDescriptionToListings < ActiveRecord::Migration
  def change
    add_column :listings, :custom, :boolean
    add_column :listings, :long_description, :text
  end
end
