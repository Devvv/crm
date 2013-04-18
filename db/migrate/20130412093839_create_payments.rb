class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|

      t.integer :user_id
      t.integer :company_id
      t.float :amount
      t.integer :plan
      t.integer :paid, :default => 0

      t.timestamps
    end
  end
end
