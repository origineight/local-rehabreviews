class AddCreatedByToFacilities < ActiveRecord::Migration
  def change
    add_column :facilities, :created_by, :integer
  end
end
