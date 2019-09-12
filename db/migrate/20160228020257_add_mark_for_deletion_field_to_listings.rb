class AddMarkForDeletionFieldToListings < ActiveRecord::Migration
  def change
    add_column :listings, :mark_for_deletion, :boolean, default: false
  end
end
