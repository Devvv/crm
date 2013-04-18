class SetDefaultForInvite < ActiveRecord::Migration
  def change
    change_column :invites, :activated, :integer, :null => false, :default => 0
  end
end
