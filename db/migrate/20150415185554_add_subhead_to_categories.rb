class AddSubheadToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :category_subhead, :string
  end
end
