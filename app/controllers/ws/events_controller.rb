class Ws::EventsController < WsController

  def create
  end

  def update
  end

  def destroy
    #puts "event destroy"
    #puts current_user.id.inspect
    event = Event.find(message[:id])
    #puts event.user_id.inspect
    #puts event.inspect
    if event.user_id == current_user.id
      if event.destroy
        #puts "event_destroy"
        #WebsocketRails["user_#{current_user.id}"].trigger "new_event"
        #trigger_success event
      else
        trigger_failure event
      end
    else
      trigger_failure event
    end
  end

end