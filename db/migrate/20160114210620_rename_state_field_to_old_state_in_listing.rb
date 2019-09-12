class RenameStateFieldToOldStateInListing < ActiveRecord::Migration
  def change
    rename_column :listings, :state, :old_state
  end
end
