class DropOldTables < ActiveRecord::Migration
  def change
    drop_table :therapists
    drop_table :facilities
    drop_table :payments
    drop_table :upgrades
  end
end
