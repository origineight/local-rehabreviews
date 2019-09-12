class AddDirectoryIdToListings < ActiveRecord::Migration
  def change
    add_column :listings, :directory_id, :integer
  end
end
