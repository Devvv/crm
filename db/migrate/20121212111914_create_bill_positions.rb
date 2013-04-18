class CreateBillPositions < ActiveRecord::Migration
  def change



    create_table :bill_positions do |t|
      t.integer :bill_total_id
      t.decimal :count,   :precision => 12, :scale => 2
      t.string :units
      t.decimal :price,   :precision => 12, :scale => 2
      t.decimal :sum,     :precision => 12, :scale => 2

      t.timestamps
    end
  end
end
