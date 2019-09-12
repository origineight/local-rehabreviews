class AddBoostToTherapists < ActiveRecord::Migration
  def change
    add_column :therapists, :boost, :integer
    add_column :therapists, :published, :boolean
  end
end
