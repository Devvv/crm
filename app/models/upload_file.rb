include ActionView::Helpers::NumberHelper
class UploadFile < ActiveRecord::Base
  attr_accessible :name, :file, :company_id, :feed_id, :history_id, :file_file_size, :file_content_type, :file_file_name

  has_attached_file :file, :path => :default_path, :url => :default_url
  belongs_to :feed
  belongs_to :company

  after_create :count_store
  after_destroy :count_store
  private
  def count_store
    company = Company.find(self.company_id)
    if company
      count = 0
      if company.upload_files.exists?
        company.upload_files.each do |file|
          count += file.file_file_size.to_f
        end
      end
      company.update_attribute :store_count, count
      WebsocketRails["company_#{company.id}"].trigger(:update_store, {:store_count => number_to_human_size(count, {:locale => :en}), :store_limit => number_to_human_size(company.store_limit, {:locale => :en})})
    end
  end
  def count_store_create
    company = Company.find(self.company_id)
    if company
      count = company.store_count.to_f + self.file_file_size.to_f
      company.update_attribute :store_count, count
      WebsocketRails["company_#{company.id}"].trigger(:update_store, {:store_count => number_to_human_size(count, {:locale => :en}), :store_limit => number_to_human_size(company.store_limit, {:locale => :en})})
    end
  end
  def count_store_destroy
    company = Company.find(self.company_id)
    if company
      puts self.inspect
      count = company.store_count.to_f - self.file_file_size.to_f
      count = count > 0 ? count : 0
      company.update_attribute :store_count, count
      WebsocketRails["company_#{company.id}"].trigger(:update_store, {:store_count => number_to_human_size(count, {:locale => :en}), :store_limit => number_to_human_size(company.store_limit, {:locale => :en})})
    end
  end
  def default_path
    ":rails_root/public/system/" + self.company_id.to_s + "/:class/:attachment/:id/:style/:basename.:extension"
  end
  def default_url
    "/system/" + self.company_id.to_s + "/:class/:attachment/:id/:style/:basename.:extension"
  end

end
