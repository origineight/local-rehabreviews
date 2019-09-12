class RemoveOldColumnsFromFacilities < ActiveRecord::Migration
  def up
    remove_column :facilities, :services_offered
    remove_column :facilities, :treatment_offered
    remove_column :facilities, :facility_type
    remove_column :facilities, :additional_considerations
    remove_column :facilities, :payment_accepted
    remove_column :facilities, :payment_assistance
    remove_column :facilities, :additional_languages
    remove_column :facilities, :addictions_treated
    remove_column :facilities, :co_occurring
  end

  def down
    add_column :facilities, :services_offered, :text
    add_column :facilities, :treatment_offered, :text
    add_column :facilities, :facility_type, :text
    add_column :facilities, :additional_considerations, :text
    add_column :facilities, :payment_accepted, :text
    add_column :facilities, :payment_assistance, :text
    add_column :facilities, :additional_languages, :string
    add_column :facilities, :addictions_treated, :string
    add_column :facilities, :co_occurring, :string
  end
end
