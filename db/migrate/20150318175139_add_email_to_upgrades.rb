class AddEmailToUpgrades < ActiveRecord::Migration
  def change
    add_column :upgrades, :paypal_email, :string
  end
end
