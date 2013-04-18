class AddPublicToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :public, :integer, :null => false, :default => 0
    add_column :user_companies, :public, :integer, :null => false, :default => 0
    add_column :users, :public, :integer, :null => false, :default => 0
  end
end
