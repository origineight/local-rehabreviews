class AddInitialsToRatings < ActiveRecord::Migration
  def change
    add_column :ratings, :initials, :string
    add_column :ratings, :attended, :boolean
    add_column :ratings, :approved, :string
    remove_column :ratings, :member_id
  end
end
