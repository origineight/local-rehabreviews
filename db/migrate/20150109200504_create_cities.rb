class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name
      t.string :slug
      t.string :state
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
