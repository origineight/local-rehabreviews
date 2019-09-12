class AddBoostByStateToListings < ActiveRecord::Migration
  def change
    add_column :listings, :state_boost, :boolean
  end
end
