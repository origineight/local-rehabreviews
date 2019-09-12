class AddNameEmailPhoneToClaims < ActiveRecord::Migration
  def change
    add_column :claims, :name, :string
    add_column :claims, :email, :string
    add_column :claims, :phone, :string
  end
end
