class Chat < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :updated_at, :user_id, :name, :unread

  has_many :chat_messages

  has_many :chat_users
  has_many :users, :through => :chat_users

end