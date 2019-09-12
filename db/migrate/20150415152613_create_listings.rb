class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.string :name
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :suffix
      t.string :title
      t.string :gender
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :phone
      t.string :fax
      t.string :website
      t.text :description
      t.string :meta_title
      t.text :meta_description
      t.text :addictions_treated
      t.text :services_offered
      t.text :treatment_offered
      t.text :facility_type
      t.text :additional_considerations
      t.text :payment_accepted
      t.text :payment_assistance
      t.text :additional_languages
      t.text :co_occurring
      t.text :insurance_accepted
      t.text :specialties

      t.timestamps
    end
  end
end
