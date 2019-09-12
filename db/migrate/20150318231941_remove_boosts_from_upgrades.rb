class RemoveBoostsFromUpgrades < ActiveRecord::Migration
  def change
    remove_column :upgrades, :upgrade_city, :string
    remove_column :upgrades, :upgrade_state, :string
    remove_column :upgrades, :upgrade_zip, :string
    remove_column :upgrades, :paypal_email, :string
  end
end
