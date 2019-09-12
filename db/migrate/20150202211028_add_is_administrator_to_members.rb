class AddIsAdministratorToMembers < ActiveRecord::Migration
  def change
    add_column :members, :is_administrator, :boolean
  end
end
