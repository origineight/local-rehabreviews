class CreateBenefitsCheckNotifications < ActiveRecord::Migration
  def change
    create_table :benefits_check_notifications do |t|
      t.string :subject,  null: false
      t.text :content,  null: false
      t.text :insurance_types, array: true, default: []
      t.string :submitted_from
      t.string :submitted_to

      t.timestamps
    end
  end
end
