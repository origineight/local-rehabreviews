class AddDescriptionToClaims < ActiveRecord::Migration
  def change
    add_column :claims, :description, :text
  end
end
