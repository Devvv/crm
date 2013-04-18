class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.integer :user_id
      t.integer :type_id
      t.integer :feed_id
      t.text :text

      t.timestamps
    end
  end
end
