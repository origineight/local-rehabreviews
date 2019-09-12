class AddStatusToUpgrades < ActiveRecord::Migration
  def change
    add_column :upgrades, :status, :string
  end
end
