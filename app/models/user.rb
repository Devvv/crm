class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :surname, :subname, :photo, :phone, :vacancy,
                  :head, :email, :password, :password_confirmation, :remember_me,
                  :active, :last_company

  #validates_attachment :photo, :presence => true,
  #                     :content_type => { :content_type => ["image/jpg", "image/png"] },
  #                     :size => { :in => 0..1000.kilobytes }

  has_many :feeds
  has_many :histories
  has_many :contacts

  has_many :events

  has_and_belongs_to_many :feeds

  has_many :user_companies, :dependent => :destroy
  has_many :companies, :through => :user_companies

  has_many :chat_users, :dependent => :destroy
  has_many :chats, :through => :chat_users
  #has_many :companies

  has_many :emails
  has_many :emails_archives

  has_many :invites, :foreign_key => "user_to"

  has_many :authentications

  has_attached_file :photo,
                    #:url => :default_url,
                    #:path => :default_path,
                    :styles => { :medium => "103x103#", :thumb => "40x40#" }

  def get_connection
    res = nil
    if self.last_company.to_i > 0
      res = UserCompany.where({:company_id => self.last_company, :user_id => self.id}).first
    end
    res
  end

  def get_company
    res = nil
    if self.last_company.to_i > 0
      res = Company.find(self.last_company)
    end
    res
  end

  def get_name
    if self.name.blank?
      self.email
    else
      if !self.surname.blank?
        self.surname.to_s + " " + self.name.to_s
      else
        self.name.to_s
      end
    end
  end

  def head=(head)
    if User.where(:id => head).exists?
      self.user_id = head
    end
  end

  def get_providers
    providers =  self.authentications.pluck(:provider)
    providers
  end

  def self.from_omniauth(auth)
    authentication = Authentication.find_by_provider_and_uuid(auth['provider'], auth['uid'])
    if authentication && authentication.user
      authentication.user
    end
  end

  #def name
  #  if super().blank?
  #    self.email
  #  end
  #end

  #def appointment
  #  if super().blank?
  #    I18n.t(:no_posts)
  #  end
  #end

  #private
  #def default_url
  #  "/photo/" + self.id.to_s + "/:style/:basename.:extension"
  #end
  #
  #def default_path
  #  ":rails_root/public/photo/" + self.id.to_s + "/:style/:basename.:extension"
  #end

end
