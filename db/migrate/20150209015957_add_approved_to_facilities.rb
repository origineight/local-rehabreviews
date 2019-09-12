class AddApprovedToFacilities < ActiveRecord::Migration
  def change
    add_column :facilities, :approved, :boolean
  end
end
