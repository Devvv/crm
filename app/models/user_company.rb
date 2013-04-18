class UserCompany < ActiveRecord::Base
  attr_accessible :user_id, :company_id, :access, :head_id, :appointment

  belongs_to :user
  belongs_to :company

end
