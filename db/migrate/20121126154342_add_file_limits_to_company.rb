class AddFileLimitsToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :store_count, :float, :null => false, :default => 0
    add_column :companies, :store_limit, :float, :null => false, :default => 104857600
  end
end
