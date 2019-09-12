class AddNeedsReviewedFieldToListings < ActiveRecord::Migration
  def change
    add_column :listings, :needs_reviewed, :boolean
  end
end
