class AddNumberOfDuplicatesFieldToListings < ActiveRecord::Migration
  def change
    add_column :listings, :number_of_duplicates, :integer
  end
end
