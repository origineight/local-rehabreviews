class AddSocialLinksToListings < ActiveRecord::Migration
  def up
    add_column :listings, :facebook, :string
    add_column :listings, :twitter, :string
    add_column :listings, :instagram, :string
  end
  def down
    remove_column :listings, :facebook
    remove_column :listings, :twitter
    remove_column :listings, :instagram
  end
end
