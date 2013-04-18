class ChatMessage < ActiveRecord::Base

  attr_accessible :user_id, :chat_id, :text, :status

  def text
    if self.status == 1
      ""
    else
      super()
    end
  end

  belongs_to :chat
  belongs_to :user
end
