class CreateClaims < ActiveRecord::Migration
  def change
    create_table :claims do |t|
      t.integer :member_id
      t.integer :therapist_id
      t.integer :facility_id
      t.string :approved

      t.timestamps
    end
  end
end
