class ChangeForToToFeed < ActiveRecord::Migration
  def change
    rename_column :feeds, :for, :user_to
  end
end
