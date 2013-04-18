class SetDefaultsPublicTo1 < ActiveRecord::Migration
  def change
    change_column :users, :public, :integer, :null => false, :default => 1
    change_column :companies, :public, :integer, :null => false, :default => 1
  end
end
