class Invite < ActiveRecord::Base
  attr_accessible :user_from, :user_to, :code, :to, :expire, :company_id, :access, :activated, :cr
  belongs_to :user, :foreign_key => "user_to"
  belongs_to :company

  scope :actived, where("expire > ? AND activated = 0", Time.now)
end
