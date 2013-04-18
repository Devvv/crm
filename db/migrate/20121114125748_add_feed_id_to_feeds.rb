class AddFeedIdToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :feed_id, :integer, :null => false, :default => 0
  end
end
