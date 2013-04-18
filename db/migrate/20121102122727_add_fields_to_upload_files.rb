class AddFieldsToUploadFiles < ActiveRecord::Migration
  def change
    add_column :upload_files, :feed_id, :integer, :null => false, :default => 0
    add_column :upload_files, :history_id, :integer, :null => false, :default => 0
  end
end
