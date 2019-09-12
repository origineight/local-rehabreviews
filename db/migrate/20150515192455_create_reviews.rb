class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :name
      t.text :body
      t.string :photo_url
      t.string :permalink_url

      t.timestamps
    end
  end
end
