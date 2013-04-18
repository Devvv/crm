class CreateUsersFeeds < ActiveRecord::Migration
  def change
    create_table :feeds_users, :id => false do |t|
      t.integer :user_id
      t.integer :feed_id
    end
  end
end
