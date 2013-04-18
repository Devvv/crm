class SetDefaultToChatMessages < ActiveRecord::Migration
  def up
    change_column :chat_messages, :status, :integer, :default => 0
  end

  def down
  end
end
