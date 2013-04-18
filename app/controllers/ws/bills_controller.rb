class Ws::BillsController < WsController

  def create
    bill = Bill.new(message)
    if bill.save      
      WebsocketRails["company_#{bill.feed.company_id}"].trigger(:create_bill, bill)
      trigger_success bill
    else
      trigger_failure bill
    end
  end

  def update
    if message[:id].to_i > 0  
      if message[:company_id].to_i > 0
        conn = UserCompany.where(:company_id => message[:company_id], :user_id => current_user.id).first
      else
        conn = UserCompany.where(:user_id => current_user.id).first
      end
      bill = Bill.find(message[:id])      
      if bill.update_attributes(message)        
        bill[:can_edit] = (conn.access.to_i >= 2 || bill.user_id == current_user.id ) ? 1 : 0
        WebsocketRails["company_#{bill.feed.company_id}"].trigger(:update_bill, bill)
        trigger_success bill
      else
        trigger_failure bill
      end
    else
      message[:user_id] = current_user.id
      bill = Bill.create message 
      WebsocketRails["company_#{bill.feed.company_id}"].trigger(:create_bill, bill)
      trigger_success bill     
    end
  end

  def destroy
    bill = Bill.find(message[:id])
    if bill.destroy      
      WebsocketRails["company_#{bill.feed.company_id}"].trigger(:destroy_bill, bill)
      trigger_success bill
    else
      trigger_failure bill
    end
  end

end