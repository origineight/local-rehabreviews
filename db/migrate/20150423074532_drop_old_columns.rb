class DropOldColumns < ActiveRecord::Migration
  def change
    remove_column :claims, :facility_id
    remove_column :claims, :therapist_id
    remove_column :listings, :gender
    remove_column :listings, :fax
    remove_column :listings, :addictions_treated
    remove_column :listings, :services_offered
    remove_column :listings, :treatment_offered
    remove_column :listings, :facility_type
    remove_column :listings, :additional_considerations
    remove_column :listings, :payment_accepted
    remove_column :listings, :payment_assistance
    remove_column :listings, :additional_languages
    remove_column :listings, :co_occurring
    remove_column :listings, :insurance_accepted
    remove_column :listings, :specialties
    remove_column :listings, :long_description
    remove_column :ratings, :facility_id
    remove_column :ratings, :therapist_id
    remove_column :uploads, :facility_id
    remove_column :uploads, :therapist_id
  end
end
