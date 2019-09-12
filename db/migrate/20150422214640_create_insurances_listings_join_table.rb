class CreateInsurancesListingsJoinTable < ActiveRecord::Migration
  def change
    create_table :insurances_listings, id: false do |t|
      t.integer :insurance_id
      t.integer :listing_id
    end
  end
end