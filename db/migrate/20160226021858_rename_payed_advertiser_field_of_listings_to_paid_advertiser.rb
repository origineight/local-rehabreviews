class RenamePayedAdvertiserFieldOfListingsToPaidAdvertiser < ActiveRecord::Migration
  def change
    rename_column :listings, :payed_advertiser, :paid_advertiser
  end
end
