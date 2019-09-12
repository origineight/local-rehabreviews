class AddIndices < ActiveRecord::Migration
  def self.up
    add_index :category_links, [:listing_id, :category_id], :unique => true
  end
  def self.down
    drop_index :category_links, [:listing_id, :category_id]
  end
end
