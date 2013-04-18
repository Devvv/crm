class CreateChat < ActiveRecord::Migration
  def change
    create_table :chats do |t|

      t.integer :user_id
      t.string :name

      t.timestamps

    end
  end
end
