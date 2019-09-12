class AddMapImageFieldToListing < ActiveRecord::Migration
  def change
    add_attachment :listings, :map_image, :medium_map_image, :small_map_image
  end
end
