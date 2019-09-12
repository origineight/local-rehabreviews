class AddRequiredIndexesToListings < ActiveRecord::Migration
  def change
    add_index(:listings, :slug)
  end
end
