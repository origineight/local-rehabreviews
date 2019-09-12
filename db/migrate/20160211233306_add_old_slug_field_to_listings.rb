class AddOldSlugFieldToListings < ActiveRecord::Migration
  def change
    add_column :listings, :old_slug, :string, index: true
  end
end
