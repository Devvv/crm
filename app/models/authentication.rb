class Authentication < ActiveRecord::Base
  attr_accessible :provider, :user_id, :uuid
  belongs_to :user
end
