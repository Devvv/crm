class Ws::ChatsController < WsController

  def create

  end

  def update

    chat_find = Chat.find_by_sql( "SELECT chats.* FROM chats WHERE 1 = ( SELECT COUNT(id) FROM chat_users WHERE chat_id = chats.id AND user_id = #{current_user.id.to_i()} ) AND 1 = ( SELECT COUNT(id) FROM chat_users WHERE chat_id = chats.id AND user_id = #{message["with_id"].to_i()} ) " )
    #puts chat_find.count
        #Chat.where( :chat_users => [ current_user.id, message["with_id"] ] )
    if chat_find.count > 0

      ch = chat_find.first
      #ch[:users] = ch.users
      ch['users'] = ch.users.map do |u|
        u[:photo_path_thumb] = u.photo(:thumb)
        u[:photo_path_medium] = u.photo(:medium)
      end

      chat2user = ChatUser.where( :chat_id => ch.id, :user_id => current_user.id ).first

      if chat2user
        ch['unread'] = chat2user.unread
        ch['is_hidden'] = chat2user.is_hidden
      end

      ch.users.each do |u|
        WebsocketRails["user_#{u.id}"].trigger(:open_chat, ch)
      end
      trigger_success ch
    else

      ch = Chat.new(message)
      ch.user_id = current_user.id
      # добавление пользователей в чат
      ch.users = [ current_user, User.find(message["with_id"]) ]
      if ch.save
        #ch[:users] = ch.users
        ch['users'] = ch.users.map do |u|
          u[:photo_path_thumb] = u.photo(:thumb)
          u[:photo_path_medium] = u.photo(:medium)
        end

        chat2user = ChatUser.where( :chat_id => ch.id, :user_id => current_user.id ).first

        if chat2user
          ch['unread'] = chat2user.unread
          ch['is_hidden'] = chat2user.is_hidden
        end

        ch.users.each do |u|
          WebsocketRails["user_#{u.id}"].trigger(:open_chat, ch)
        end

        ChatUser.where( :chat_id => ch.id ).each do |cu|
          cu.update_attributes( :unread => 0, :is_hidden => 0 )
        end

        #puts "trololo test"

        trigger_success ch
      else
        trigger_failure ch
      end
    end
  end

  def reading
    if message['id']
      chat = current_user.chats.find(message['id'])
      if chat
        unread = ChatUser.where(:chat_id => chat.id, :user_id => current_user.id).first
        if unread
          unread.update_attribute(:unread, 0)
          trigger_success chat
        end
      end
    end
  end

  def hide_chat
    if message['id']
      chat = current_user.chats.find(message['id'])
      if chat
        #trigger_success chat
        hidden = ChatUser.where(:chat_id => chat.id, :user_id => current_user.id).first
        if hidden
          hidden.update_attribute(:is_hidden, message['is_hidden'])
          trigger_success chat
        end
      end
    end
  end

  def type_text
    puts message.inspect
    if message['chat_id']
      chat = current_user.chats.find(message['chat_id'])
      if chat
        ch = {}
        ch['user_id'] = current_user.id
        ch['chat_id'] = chat.id
        WebsocketRails["chat_#{chat.id}"].trigger(:type_text, ch)
        #trigger_success chat
      end
    end

  end

end