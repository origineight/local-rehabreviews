class AddAdditionalDataToListings < ActiveRecord::Migration
  def change
    add_column :listings, :additional_data, :text
  end
end
