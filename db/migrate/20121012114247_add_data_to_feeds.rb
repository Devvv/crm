class AddDataToFeeds < ActiveRecord::Migration
  def change
  	add_column :feeds, :start, :datetime
  	add_column :feeds, :end, :datetime
  	add_column :feeds, :total, :float
  	add_column :feeds, :importance, :integer
  end
end
