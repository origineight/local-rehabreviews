class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :initial
      t.string :title
      t.text :body
      t.integer :rating_id

      t.timestamps
    end
  end
end
