class AddCompanyToAll < ActiveRecord::Migration
  def change
    add_column :feeds, :company_id, :integer
    add_column :histories, :company_id, :integer
    add_column :upload_files, :company_id, :integer
  end
end
