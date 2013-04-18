class CreateBillTotals < ActiveRecord::Migration
  def change

    create_table :bill_totals do |t|
      t.integer :feed_id
      t.decimal :sum,     :precision => 12, :scale => 2
      t.integer :discount,:default => 0
      t.string :num
      t.datetime :bill_date

      t.timestamps
    end
  end
end
