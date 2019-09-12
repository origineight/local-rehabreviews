class RenameNewColumnsToOld < ActiveRecord::Migration
  def change
    rename_column :facilities, :addictions, :addictions_treated
    rename_column :facilities, :services, :services_offered
    rename_column :facilities, :treatment, :treatment_offered
    rename_column :facilities, :fac_type, :facility_type
    rename_column :facilities, :addl_considerations, :additional_considerations
    rename_column :facilities, :payment_acc, :payment_accepted
    rename_column :facilities, :payment_ass, :payment_assistance
    rename_column :facilities, :addl_languages, :additional_languages
    rename_column :facilities, :coocurr, :co_occurring
  end
end