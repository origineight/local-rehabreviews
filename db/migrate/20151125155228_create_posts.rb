class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :author
      t.string :title,  null: false
      t.text :description,  null: false
      t.text :content,      null: false
      t.attachment :image
      t.references :member, index: true, null: false

      t.timestamps
    end
  end
end
