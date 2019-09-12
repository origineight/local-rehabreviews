class AddListingIdsToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :listing_id, :integer
    add_column :claims, :listing_id, :integer
    add_column :ratings, :listing_id, :integer
  end
end
