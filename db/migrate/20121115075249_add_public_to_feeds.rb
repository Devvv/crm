class AddPublicToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :public, :integer, :null => false, :default => 0
  end
end
