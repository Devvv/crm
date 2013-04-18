class Company < ActiveRecord::Base

  # plans:
  # 0 - startup (100 MB)
  # 1 - project (1 GB)
  # 2 - company (10 GB)

  attr_accessible :name, :text, :code, :public, :rating, :type_id,
                  :user_id, :store_limit, :store_count, :phone,
                  :address, :inn, :kpp, :ogrn, :reg_date

  has_many :user_companies, :dependent => :destroy
  has_many :users, :through => :user_companies
  belongs_to :user
  has_many :feeds, :dependent => :destroy
  has_many :upload_files, :dependent => :destroy

  has_many :invites, :dependent => :destroy

  has_many :contacts, :dependent => :destroy
  has_many :histories, :dependent => :destroy

  has_attached_file :photo,
                    #:url => :default_url,
                    #:path => :default_path,
                    :styles => { :medium => "103x103#", :thumb => "40x40#" }



end
