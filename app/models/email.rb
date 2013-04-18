class Email < ActiveRecord::Base
  attr_accessible :email, :password, :user_id, :port, :server, :smtp_address, :smtp_port, :smtp_domain, :smtp_user_name, :smtp_authentication, :smtp_enable_starttls_auto, :smtp_password

  belongs_to :user
end
