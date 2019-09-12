class AddDuplicateIndexToListings < ActiveRecord::Migration
  def change
    add_index(:listings, :duplicate)
  end
end
