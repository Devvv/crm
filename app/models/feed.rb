include ActionView::Helpers::NumberHelper
class Feed < ActiveRecord::Base

  attr_accessible :name, :text, :user_id, :type_id, :start, :end,
                  :importance, :company_id, :status_id, :user_to,
                  :refers, :public, :feed_id, :conts

  belongs_to :user
  belongs_to :company

  has_many :feeds
  belongs_to :feed

  has_and_belongs_to_many :users
  has_and_belongs_to_many :contacts

  has_many :histories, :dependent => :destroy
  has_many :upload_files, :dependent => :destroy

  has_many :bills, :dependent => :destroy

  scope :posts, where(:type_id => 0)
  scope :tasks, where(:type_id => 1)
  scope :deals, where(:type_id => 2)
  scope :events, where(:type_id => 3)
  scope :docs, where(:type_id => 4)

  #def created_at
  #  super().strftime('%d.%m.%y %H:%M')
  #end

  def users=(users)
    if users.length > 0
      us = User.where(:id => users)
    else
      us = []
    end
    super(us)
  end

  def refers=(users)
    self.users = users
  end

  def contacts=(users)
    if users.length > 0
      us = Contact.where(:id => users)
    else
      us = []
    end
    super(us)
  end

  def conts=(users)
    self.contacts = users
  end

  def start
    if super()
      super().getlocal
    else
      Time.now.getlocal
    end
  end

  def end
    if super()
      super().getlocal
    else
      (Time.now + 1.day).getlocal
    end
  end

  def status
    I18n.t("status_#{self.status_id.to_i}")
  end

  after_create :count_store_create
  before_destroy :count_store_destroy
  private
  def count_store_create
    company = Company.find(self.company_id)
    if company
      count = company.store_count.to_f + 20000
      company.update_attribute :store_count, count
      WebsocketRails["company_#{company.id}"].trigger(:update_store, {:store_count => number_to_human_size(count, {:locale => :en}), :store_limit => number_to_human_size(company.store_limit, {:locale => :en})})
    end
  end
  def count_store_destroy
    company = Company.find(self.company_id)
    if company
      count = company.store_count.to_f - 20000
      count = count > 0 ? count : 0
      company.update_attribute :store_count, count
      WebsocketRails["company_#{company.id}"].trigger(:update_store, {:store_count => number_to_human_size(count, {:locale => :en}), :store_limit => number_to_human_size(company.store_limit, {:locale => :en})})
    end
  end

end
