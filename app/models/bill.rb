class Bill < ActiveRecord::Base
  attr_accessible :bill_date, :feed_id, :discount, :num, :sum, :name, :user_id, :status_id
  belongs_to :feed
  has_many :bill_positions, :dependent => :destroy

  before_update :total_sum  

  private

  def total_sum
    #sum = self.BillPosition.find_all_by_bill_id(self.id).sum("sum")
    sum = self.bill_positions.sum("sum")
    if sum.blank?
      sum = 0
    end  
    self.sum = sum  
  end

end