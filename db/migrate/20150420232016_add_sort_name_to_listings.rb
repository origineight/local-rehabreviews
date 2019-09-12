class AddSortNameToListings < ActiveRecord::Migration
  def change
    add_column :listings, :sort_name, :string
  end
end
