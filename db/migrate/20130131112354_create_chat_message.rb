class CreateChatMessage < ActiveRecord::Migration
  def change
    create_table :chat_messages do |t|

      t.integer :user_id
      t.integer :chat_id
      t.text :text

      t.timestamps
    end
  end
end
