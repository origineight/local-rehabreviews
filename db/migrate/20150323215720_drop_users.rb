class DropUsers < ActiveRecord::Migration
  def change
    drop_table :users
    remove_column :therapists, :legacy_latitude
    remove_column :therapists, :legacy_longitude
    remove_column :members, :user_name
  end
end
