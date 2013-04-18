class History < ActiveRecord::Base

  # type_id:
  # 0 - comment
  # 1 - создан feed
  # 2 - изменен feed
  # 3 - загружен файл
  # 4 - удален файл
  # 5 - удален feed

  attr_accessible :user_id, :type_id, :feed_id, :text, :company_id
  belongs_to :user
  belongs_to :feed
  belongs_to :company
  before_save :count_plus
  before_destroy :count_minus

  has_many :events

  def count_plus
    if self.feed_id.to_i > 0 && self.type_id.to_i == 0
      feed = Feed.find(self.feed_id)
      feed.update_attribute :comments, feed.comments.to_i + 1
    end
  end

  def count_minus
    if self.feed_id.to_i > 0 && self.type_id.to_i == 0
      feed = Feed.find(self.feed_id)
      feed.update_attribute :comments, feed.comments.to_i - 1
    end
  end

end
