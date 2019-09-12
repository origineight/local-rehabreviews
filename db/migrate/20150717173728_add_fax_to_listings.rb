class AddFaxToListings < ActiveRecord::Migration
  def change
    add_column :listings, :fax, :string
  end
end
