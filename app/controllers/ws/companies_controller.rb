class Ws::CompaniesController < WsController

  def update
    company = Company.find(message[:id])
    conn = current_user.get_connection
    if conn.access.to_i >= 2 and company.id.to_i == conn.company_id.to_i
      if company.update_attributes(message)
        broadcast_message :update_company, company
        #WebsocketRails["company_#{feed.company_id}"].trigger(:update_feed, feed)
        trigger_success company
      else
        trigger_failure company
      end
    else
      trigger_success company
    end
  end

  def destroy
  end

end