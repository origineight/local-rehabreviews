class AddPaypalTokensToUpgrades < ActiveRecord::Migration
  def change
    add_column :upgrades, :paypal_customer_token, :string
    add_column :upgrades, :paypal_recurring_profile_token, :string
  end
end
