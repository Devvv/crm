class RenameBillTotalToBillId < ActiveRecord::Migration
  def up
    rename_column :bill_positions, :bill_total_id, :bill_id
  end
end
