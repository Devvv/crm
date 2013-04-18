class Ws::PositionsController < WsController
  
  def create
  	position = BillPosition.new(message)
    if position.save      
      WebsocketRails["company_#{message[:company_id]}"].trigger(:create_position, position)
      trigger_success position
    else
      trigger_failure position
    end
  end

  def update
    if message[:id].to_i > 0      
      position = BillPosition.find(message[:id])      
      if position.update_attributes(message)                
        WebsocketRails["company_#{message[:company_id]}"].trigger(:update_position, position)
        if message[:sum] != position.sum
          WebsocketRails["company_#{message[:company_id]}"].trigger(:check_sum, position.bill_id)  
        end  
        trigger_success position
      else
        trigger_failure position
      end
    else      
      position = BillPosition.create message         
      WebsocketRails["company_#{message[:company_id]}"].trigger(:create_position, position)
      trigger_success feed  
    end
  end

  def destroy
    position = BillPosition.find(message[:id])
    if position.destroy      
      WebsocketRails["company_#{message[:company_id]}"].trigger(:destroy_position, position)
      trigger_success position
    else
      trigger_failure position
    end
  end

end