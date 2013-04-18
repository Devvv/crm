class AddTypeToFeed < ActiveRecord::Migration
  def change
    add_column :feeds, :type_id, :integer, {:default => 0}
  end
end
