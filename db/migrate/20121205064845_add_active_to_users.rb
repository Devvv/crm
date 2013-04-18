class AddActiveToUsers < ActiveRecord::Migration
  def change
    add_column :users, :active, :integer, :null => false, :default => 1
  end
end
