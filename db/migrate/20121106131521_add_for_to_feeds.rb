class AddForToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :for, :integer
  end
end
