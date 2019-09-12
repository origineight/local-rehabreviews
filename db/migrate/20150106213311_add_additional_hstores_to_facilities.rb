class AddAdditionalHstoresToFacilities < ActiveRecord::Migration
  def change
    add_column :facilities, :services, :hstore
    add_column :facilities, :treatment, :hstore
    add_column :facilities, :fac_type, :hstore
    add_column :facilities, :addl_considerations, :hstore
    add_column :facilities, :payment_acc, :hstore
    add_column :facilities, :payment_ass, :hstore
    add_column :facilities, :addl_languages, :hstore
    add_column :facilities, :coocurr, :hstore
  end
end
