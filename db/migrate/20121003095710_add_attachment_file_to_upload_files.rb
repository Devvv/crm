class AddAttachmentFileToUploadFiles < ActiveRecord::Migration
  def self.up
    change_table :upload_files do |t|
      t.has_attached_file :file
    end
  end

  def self.down
    drop_attached_file :upload_files, :file
  end
end
