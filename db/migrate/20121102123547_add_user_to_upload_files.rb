class AddUserToUploadFiles < ActiveRecord::Migration
  def change
    add_column :upload_files, :user_id, :integer
  end
end
