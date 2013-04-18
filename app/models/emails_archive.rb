class EmailsArchive < ActiveRecord::Base
  attr_accessible :date, :message_id, :subject, :text, :user_id

  belongs_to :user
end
