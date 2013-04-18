class AddDefaultToCompanyType < ActiveRecord::Migration
  def change
    change_column :companies, :type_id, :integer, :null => false, :default => 0
  end
end
