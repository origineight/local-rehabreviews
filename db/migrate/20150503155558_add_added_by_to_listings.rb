class AddAddedByToListings < ActiveRecord::Migration
  def change
    add_column :listings, :added_by, :string
  end
end
