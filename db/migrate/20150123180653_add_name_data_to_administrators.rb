class AddNameDataToAdministrators < ActiveRecord::Migration
  def change
    add_column :administrators, :first_name, :string
    add_column :administrators, :last_name, :string
  end
end
