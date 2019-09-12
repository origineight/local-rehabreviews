class AddPayedAdvertiserFieldToListings < ActiveRecord::Migration
  def change
    add_column :listings, :payed_advertiser, :boolean, default: false
  end
end
