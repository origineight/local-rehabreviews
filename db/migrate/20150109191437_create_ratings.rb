class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :user_id
      t.integer :therapist_id
      t.integer :facility_id
      t.string :title
      t.text :body
      t.string :rating

      t.timestamps
    end
  end
end
