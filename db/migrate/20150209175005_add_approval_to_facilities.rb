class AddApprovalToFacilities < ActiveRecord::Migration
  def change
    add_column :facilities, :approval, :string
    remove_column :facilities, :approved
    remove_column :ratings, :approved
  end
end
