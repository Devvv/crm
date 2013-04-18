class BillPosition < ActiveRecord::Base
  attr_accessible :bill_id, :count, :price, :sum, :units, :name
  belongs_to :bill

  before_save :calc_sum

  private

  def calc_sum
  	self.sum = self.count * self.price
  end	
end