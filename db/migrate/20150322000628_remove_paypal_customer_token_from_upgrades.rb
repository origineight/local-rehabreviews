class RemovePaypalCustomerTokenFromUpgrades < ActiveRecord::Migration
  def change
    remove_column :upgrades, :paypal_customer_token, :string
  end
end
