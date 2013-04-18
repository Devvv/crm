class ChangeDefaultStatusFeed < ActiveRecord::Migration
  def change
    change_column :feeds, :status_id, :integer, :null => false, :default => 0
  end
end
