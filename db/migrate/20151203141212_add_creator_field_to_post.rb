class AddCreatorFieldToPost < ActiveRecord::Migration
  def change
    add_reference :posts, :creator, polymorphic: true, index: true, null: false
    remove_reference :posts, :member
  end
end
