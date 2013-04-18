class Payment < ActiveRecord::Base
  attr_accessible :amount, :company_id, :paid, :plan, :user_id
end
