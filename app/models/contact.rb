include ActionView::Helpers::NumberHelper
class Contact < ActiveRecord::Base
  attr_accessible :name, :surname, :subname, :text, :email, :phone, :company_id, :user_id
  belongs_to :user
  belongs_to :company
  has_and_belongs_to_many :feeds

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
