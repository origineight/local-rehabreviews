class AddMoreIndices < ActiveRecord::Migration
  def self.up
    add_index :claims, :member_id
    add_index :claims, :listing_id
    add_index :insurances_listings, [:listing_id, :insurance_id], :unique => true
    add_index :languages_listings, [:listing_id, :language_id], :unique => true
    add_index :listings, :directory_id
    add_index :ratings, :listing_id
    add_index :uploads, :listing_id
  end
  def self.down
    drop_index :claims, :member_id
    drop_index :claims, :listing_id
    drop_index :insurances_listings, [:listing_id, :insurance_id]
    drop_index :languages_listings, [:listing_id, :language_id]
    drop_index :listings, :directory_id
    drop_index :ratings, :listing_id
    drop_index :uploads, :listing_id
  end
end
