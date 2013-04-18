class AddNameToPosition < ActiveRecord::Migration
  def change
    add_column :bill_positions, :name, :string
  end
end
