class CreateDuplicateListings < ActiveRecord::Migration
  def change
    create_table :duplicate_listings do |t|
      t.references :listing, index: true, null: false
      t.integer :listing_associated_id, index: true, null: false

      t.timestamps
    end
  end
end
