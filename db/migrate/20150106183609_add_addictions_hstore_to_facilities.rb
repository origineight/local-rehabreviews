class AddAddictionsHstoreToFacilities < ActiveRecord::Migration
  def change
    add_column :facilities, :addictions, :hstore
  end
end
