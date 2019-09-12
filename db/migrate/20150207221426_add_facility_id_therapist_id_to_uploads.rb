class AddFacilityIdTherapistIdToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :facility_id, :integer
    add_column :uploads, :therapist_id, :integer
  end
end
