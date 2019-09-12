class AddBoostToFacilities < ActiveRecord::Migration
  def change
    add_column :facilities, :boost, :integer
    add_column :facilities, :published, :boolean
  end
end
