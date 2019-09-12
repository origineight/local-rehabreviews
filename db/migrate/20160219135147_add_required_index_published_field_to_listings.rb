class AddRequiredIndexPublishedFieldToListings < ActiveRecord::Migration
  def change
    add_index(:listings, :published)
  end
end
