class CreateBenefitsCheckLeads < ActiveRecord::Migration
  def change
    create_table :benefits_check_leads do |t|
      t.boolean :popup, null: false
      t.string :best_time_to_call
      t.string :email, null: false
      t.string :insurance_company, null: false
      t.string :name, null: false
      t.string :phone, null: false
      t.string :referer, null: false
      t.integer :seeking_help_for, null: false
      t.integer :insurance_type, null: false

      t.timestamps
    end
  end
end
