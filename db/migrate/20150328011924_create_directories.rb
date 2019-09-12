class CreateDirectories < ActiveRecord::Migration
  def change
    create_table :directories do |t|
      t.string :name
      t.string :directory_type
      t.text :description
      t.string :meta_name
      t.text :meta_description

      t.timestamps
    end
  end
end
