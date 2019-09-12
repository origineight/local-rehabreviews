class AddStateReferenceToCities < ActiveRecord::Migration
  def change
    add_column :cities, :state_id, :integer, references: :state
  end
end
