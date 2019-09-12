class AddFeaturedToListings < ActiveRecord::Migration
  def change
    add_column :listings, :featured, :boolean
  end
end
