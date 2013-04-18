class AddDefaultToLimit < ActiveRecord::Migration
  def change
    change_column :companies, :store_limit, :float, :null => false, :default => 104857600
  end
end
