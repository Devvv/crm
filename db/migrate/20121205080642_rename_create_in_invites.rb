class RenameCreateInInvites < ActiveRecord::Migration
  def change
    rename_column :invites, :create, :cr
  end
end
