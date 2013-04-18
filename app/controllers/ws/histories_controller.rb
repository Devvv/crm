class Ws::HistoriesController < WsController

  def create
    history = History.new(message)
    if history.save
      #broadcast_message :create_feed, feed
      WebsocketRails["company_#{current_user.get_company.id}"].trigger(:add_history, history)
      #trigger_success history
    else
      trigger_failure history
    end
  end

  def update
    if message[:id].to_i > 0
      history = History.find(message[:id])
      if history.update_attributes(message)
        #broadcast_message :update_feed, feed
        WebsocketRails["company_#{current_user.get_company.id}"].trigger(:update_history, history)
        #trigger_success history
      else
        trigger_failure history
      end
    else
      message[:user_id] = current_user.id
      company_id = current_user.get_company.id
      message[:company_id] = company_id
      history = History.create message
      WebsocketRails["company_#{company_id}"].trigger(:add_history, history)
      #trigger_success history
    end
  end

  def destroy
    history = History.find(message[:id])
    if history.destroy
      #broadcast_message :destroy_feed, feed
      WebsocketRails["company_#{current_user.get_connection.company.id}"].trigger(:destroy_history, history)
      #trigger_success history
    else
      trigger_failure history
    end
  end

end