class RemoveExtraFieldsFromBenefitsCheckLead < ActiveRecord::Migration
  def change
    remove_column :benefits_check_leads, :insurance_company, :string
    remove_column :benefits_check_leads, :best_time_to_call, :string
  end
end
