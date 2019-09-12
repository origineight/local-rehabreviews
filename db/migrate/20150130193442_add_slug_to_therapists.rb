class AddSlugToTherapists < ActiveRecord::Migration
  def change
    add_column :therapists, :slug, :string
    add_index :therapists, :slug
    add_index :facilities, :slug
    add_index :cities, :slug
  end
end
