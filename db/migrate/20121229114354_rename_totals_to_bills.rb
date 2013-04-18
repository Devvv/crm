class RenameTotalsToBills < ActiveRecord::Migration
  def change
    rename_table :bill_totals, :bills
  end
end
