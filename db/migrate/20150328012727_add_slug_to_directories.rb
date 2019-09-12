class AddSlugToDirectories < ActiveRecord::Migration
  def change
    add_column :directories, :slug, :string
  end
end
