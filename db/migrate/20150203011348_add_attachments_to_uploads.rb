class AddAttachmentsToUploads < ActiveRecord::Migration
  def self.up
    add_attachment :uploads, :image
  end

  def self.down
    remove_attachment :uploads, :image
  end
end
