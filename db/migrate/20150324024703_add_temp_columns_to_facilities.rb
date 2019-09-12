class AddTempColumnsToFacilities < ActiveRecord::Migration
  def change
    add_column :facilities, :name_1, :string
    add_column :facilities, :name_2, :string
    add_column :facilities, :facility_type_temp, :text
    add_column :facilities, :services_offered_temp, :text
    add_column :facilities, :facility_classification_temp, :text
    add_column :facilities, :special_treatment_temp, :text
    add_column :facilities, :payment_accepted_temp, :text
    add_column :facilities, :payment_consideration_temp, :text
    add_column :facilities, :additional_languages_temp, :text
    add_column :facilities, :review_copy, :text
    remove_column :facilities, :meta_description, :string
    add_column :facilities, :meta_description, :text
  end
end
