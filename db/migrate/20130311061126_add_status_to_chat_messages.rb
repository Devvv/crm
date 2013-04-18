class AddStatusToChatMessages < ActiveRecord::Migration
  def change
    add_column :chat_messages, :status, :integer
  end
end
