class AddBoostByToUpgrades < ActiveRecord::Migration
  def change
    add_column :upgrades, :boost_by, :string
  end
end
