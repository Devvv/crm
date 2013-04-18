class AddCreateToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :create, :integer, :null => false, :default => 0
  end
end
