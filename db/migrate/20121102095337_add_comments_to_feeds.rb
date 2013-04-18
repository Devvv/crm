class AddCommentsToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :comments, :integer, :null => false, :default => 0
  end
end
