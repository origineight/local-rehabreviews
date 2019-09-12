class AddMemberIdToRatings < ActiveRecord::Migration
  def change
    add_column :ratings, :member_id, :integer
  end
end
