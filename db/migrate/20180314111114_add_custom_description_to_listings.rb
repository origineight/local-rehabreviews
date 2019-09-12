class AddCustomDescriptionToListings < ActiveRecord::Migration
  def up
    add_column :listings, :custom_description, :text
  end
  
  def down
    remove_column :listings, :custom_description
  end
end
