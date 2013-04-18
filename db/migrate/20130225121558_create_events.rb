class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|

      t.integer :user_id
      t.integer :history_id
      t.integer :status

      t.timestamps
    end
  end
end
