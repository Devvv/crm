class Event < ActiveRecord::Base
  attr_accessible :company_id, :history_id, :status, :user_id, :event_type, :feed_id

  # status
  # 0  - не прочитано, не отправлено
  # 10 - не прочитано, отправлено
  # 20 - прочитано, отправлено

  # event_type
  # 0 - пост
  # 1 - задачи
  # 2 - сделки
  # 3 - событие
  # 4 - документ
  # 101 - другое...
  # 102 - другое...
  # 103 - другое...


  belongs_to :user
  belongs_to :history

end
