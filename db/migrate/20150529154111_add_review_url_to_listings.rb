class AddReviewUrlToListings < ActiveRecord::Migration
  def change
    add_column :listings, :review_url, :string
  end
end
