class AddColumnToChatUsersUnread < ActiveRecord::Migration
  def change
    add_column :chat_users, :unread, :integer
  end
end
