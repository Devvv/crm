class Ws::UsersController < WsController

  def update
    link = current_user.get_connection
    user = User.find(message[:id])
    if user.update_attributes(message)
      broadcast_message :update_global_user, user
      conn = UserCompany.where({:company_id => link.company_id, :user_id => user.id}).first
      if link.access.to_i >= 2
        conn.update_attributes({:access => message[:access], :appointment => message[:appointment], :head_id => message[:user_id]})
      end
      if conn.appointment.blank?
        user[:appointment] = ""
      else
        user[:appointment] = conn.appointment
      end
      if conn.head_id.to_i > 0
        user[:user_id] = conn.head_id.to_i
      else
        user[:user_id] = 0
      end
      user[:access] = conn.access.to_i
      user[:photo_path_thumb] = user.photo(:thumb)
      user[:photo_path_medium] = user.photo(:medium)
      user[:can_edit] = link.access.to_i >= 2 ? 1 : 0
      user[:can_edit_self] = current_user.id.to_i == user.id.to_i ? 1 : 0
      WebsocketRails["company_#{link.company_id}"].trigger(:update_user, user)
      #trigger_success user
    else
      trigger_failure user
    end
  end

  def destroy
  end

end