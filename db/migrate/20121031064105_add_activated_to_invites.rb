class AddActivatedToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :activated, :integer
  end
end
