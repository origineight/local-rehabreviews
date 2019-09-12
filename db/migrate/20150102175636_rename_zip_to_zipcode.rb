class RenameZipToZipcode < ActiveRecord::Migration
  def change
    rename_column :facilities, :zip, :zipcode
    rename_column :therapists, :zip, :zipcode
  end
end