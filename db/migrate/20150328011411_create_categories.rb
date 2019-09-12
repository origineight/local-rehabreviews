class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.text :description
      t.string :meta_name
      t.text :meta_description

      t.timestamps
    end
  end
end
