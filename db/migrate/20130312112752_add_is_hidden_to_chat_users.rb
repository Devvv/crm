class AddIsHiddenToChatUsers < ActiveRecord::Migration
  def change
    add_column :chat_users, :is_hidden, :integer
  end
end
