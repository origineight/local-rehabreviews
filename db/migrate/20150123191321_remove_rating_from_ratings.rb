class RemoveRatingFromRatings < ActiveRecord::Migration
  def change
    remove_column :ratings, :rating, :string
  end
end
