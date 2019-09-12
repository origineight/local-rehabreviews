class AddApprovalToRatings < ActiveRecord::Migration
  def change
    add_column :ratings, :approval, :string
  end
end
