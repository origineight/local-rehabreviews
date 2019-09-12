class CreateCategoryLinks < ActiveRecord::Migration
  def change
    create_table :category_links do |t|
      t.integer :category_id
      t.integer :listing_id
      t.boolean :boosted

      t.timestamps
    end
  end
end
