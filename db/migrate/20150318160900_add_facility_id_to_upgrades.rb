class AddFacilityIdToUpgrades < ActiveRecord::Migration
  def change
    add_column :upgrades, :facility_id, :integer
  end
end
