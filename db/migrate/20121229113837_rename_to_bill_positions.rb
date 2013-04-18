class RenameToBillPositions < ActiveRecord::Migration
  def up
    rename_table :bills, :bill_positions
  end

end
