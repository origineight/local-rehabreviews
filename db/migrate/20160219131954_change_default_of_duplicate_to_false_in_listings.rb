class ChangeDefaultOfDuplicateToFalseInListings < ActiveRecord::Migration
  def change
    change_column :listings, :duplicate, :boolean, default: false
  end
end
