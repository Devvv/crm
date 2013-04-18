class AddHeadToUserCompanies < ActiveRecord::Migration
  def change
    add_column :user_companies, :head_id, :integer
    remove_column :users, :user_id
  end
end
