class AddFullNameFieldToListings < ActiveRecord::Migration
  def change
    add_column :listings, :full_name_field, :string
    add_column :listings, :duplicate, :boolean, default: true
  end
end
