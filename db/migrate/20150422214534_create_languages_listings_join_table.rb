class CreateLanguagesListingsJoinTable < ActiveRecord::Migration
  def change
    create_table :languages_listings, id: false do |t|
      t.integer :language_id
      t.integer :listing_id
    end
  end
end