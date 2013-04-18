class AddFieldsToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :status_id, :integer
  end
end
