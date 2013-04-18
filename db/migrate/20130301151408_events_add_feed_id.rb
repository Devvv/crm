class EventsAddFeedId < ActiveRecord::Migration
  def up
    add_column :events, :feed_id, :integer
  end

  def down
    remove_column :events, :feed_id
  end
end
