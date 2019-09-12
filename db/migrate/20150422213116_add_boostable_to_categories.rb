class AddBoostableToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :boostable, :boolean
  end
end
