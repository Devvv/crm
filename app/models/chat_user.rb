class ChatUser < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :chat_id, :user_id, :is_hidden, :unread

  belongs_to :chat
  belongs_to :user

end
