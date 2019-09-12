class AddCustomServiceToListings < ActiveRecord::Migration
  def up
    add_column :listings, :custom_service, :string
  end
  def down
    remove_column :listings, :custom_service
  end
end
