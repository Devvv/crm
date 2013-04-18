class Ws::FeedsController < WsController

  def create
    feed = Feed.new(message)
    feed.user_id = current_user.id
    company_id = current_user.last_company
    feed.company_id = company_id
    puts 'loool' + feed.inspect
    puts 'lool3' + message.inspect
    if feed.save
      puts 'loool3' + feed.inspect
      History.create({
                         :company_id => company_id,
                         :feed_id => feed.id,
                         :type_id => 1,
                         :user_id => current_user.id
                     })
      feed[:refers] = []
      feed[:conts] = []



      #broadcast_message :create_feed, feed
      WebsocketRails["company_#{company_id}"].trigger(:create_feed, feed)
      trigger_success feed
    else
      puts 'loool2' + feed.inspect
      trigger_failure feed
    end
  end

  def update
    company_id = current_user.get_company.id.to_i
    access_id = current_user.get_connection.access.to_i
    if message[:id].to_i > 0
      feed = Feed.find(message[:id])
      if access_id >= 2 or feed.user_id == current_user.id or feed.user_to == current_user.id
        old_user_to = feed.user_to
        old_users = feed.users.pluck("users.id")
        message[:users] ||= []
        message[:contacts] ||= []
        if feed.update_attributes(message)

          tmp_history = History.create({
            :company_id => company_id,
            :feed_id => feed.id,
            :type_id => 2,
            :user_id => current_user.id
          })

          if feed.user_to != old_user_to and feed.user_to > 0
            tmp_event = Event.create({
              :company_id => company_id,
              :event_type => feed.type_id,
              :history_id => tmp_history.id,
              :status => 10,
              :user_id => feed.user_to,
              :feed_id => feed.id
            })
            WebsocketRails["user_#{feed.user_to}"].trigger "new_event", tmp_event
          end

          if feed.users.pluck("users.id") != old_users
            puts "feed.users.pluck('users.id') != old_users"
            feed.users.each do |u|
              if !u.id.in?(old_users)
                tmp_event = Event.create({
                  :company_id => company_id,
                  :event_type => feed.type_id,
                  :history_id => tmp_history.id,
                  :status => 10,
                  :user_id => u.id,
                  :feed_id => feed.id
                })
                WebsocketRails["user_#{u.id}"].trigger "new_event", tmp_event
              end
            end
          end

          #broadcast_message :update_feed, feed
          feed[:refers] = feed.users.pluck(:id)
          feed[:conts] = feed.contacts.pluck(:id)

          #feed[:files] = feed.upload_files ???

          WebsocketRails["company_#{company_id}"].trigger(:update_feed, feed)
          #trigger_success feed
        else
          trigger_failure feed
        end
      else
        trigger_failure feed
      end
    else
      message[:user_id] = current_user.id
      message[:company_id] = company_id
      feed = Feed.create message
      History.create({
                         :company_id => company_id,
                         :feed_id => feed.id,
                         :type_id => 1,
                         :user_id => current_user.id
                     })
      feed[:refers] = []
      feed[:conts] = []

      WebsocketRails["company_#{company_id}"].trigger(:create_feed, feed)

      trigger_success feed
    end
  end

  def destroy
    feed = Feed.find(message[:id])
    access_id = current_user.get_connection.access.to_i
    if access_id >= 2 or feed.user_id == current_user.id
      if feed.destroy
        History.create({
                           :company_id => current_user.last_company,
                           :feed_id => message[:id],
                           :type_id => 5,
                           :user_id => current_user.id
                       })
        #broadcast_message :destroy_feed, feed
        WebsocketRails["company_#{current_user.get_company.id}"].trigger(:destroy_feed, feed)
        #trigger_success feed
      else
        trigger_failure feed
      end
    else
      trigger_failure feed
    end
  end

end