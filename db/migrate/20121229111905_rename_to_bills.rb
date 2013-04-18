class RenameToBills < ActiveRecord::Migration
  def change
    rename_table :bill_positions, :bills
  end
end
