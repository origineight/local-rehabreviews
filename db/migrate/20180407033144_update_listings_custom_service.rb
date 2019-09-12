class UpdateListingsCustomService < ActiveRecord::Migration
  def up
    change_column :listings, :custom_service, :text
  end
  def down
    change_column :listings, :custom_service, :text
  end
end
