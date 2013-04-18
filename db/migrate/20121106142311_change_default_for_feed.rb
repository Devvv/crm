class ChangeDefaultForFeed < ActiveRecord::Migration
  def change
    change_column :feeds, :for, :integer, :null => false, :default => 0
  end
end
