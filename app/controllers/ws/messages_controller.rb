class Ws::MessagesController < WsController

  def create
    mess = ChatMessage.new(message)
    mess.status = 0
    mess.user_id = current_user.id
    if mess.save
      chat = Chat.find(mess.chat_id)
      if chat

        # уведомление всех пользователей чата о новом сообщении
        chat.users.each do |u|
          WebsocketRails["user_#{u.id}"].trigger(:new_chat_message, mess)
        end

        # увеличение счетчика уведомлений для чатов всех пользователей
        chat_users_ids = ChatUser.where( :chat_id => chat.id, :user_id => chat.users.pluck('users.id').delete_if {|x| x == current_user.id} )
        ChatUser.increment_counter(:unread, chat_users_ids.pluck('chat_users.id'))

        # чаты у всех пользователей с новым сообщением становятся видимыми ( is_hidden = 0 )
        #ChatUser.where( :chat_id => chat.id ).update_attribute(:is_hidden, 0)

      end

      #trigger_success mess
    else
      trigger_failure mess
    end
  end


  def update
    mess = ChatMessage.new(message)
    mess.status = 0
    mess.user_id = current_user.id
    if mess.save
      chat = Chat.find(mess.chat_id)
      if chat

        # уведомление всех пользователей чата о новом сообщении
        chat.users.each do |u|
          WebsocketRails["user_#{u.id}"].trigger(:new_chat_message, mess)
        end

        # увеличение счетчика уведомлений для чатов всех пользователей
        chat_users_ids = ChatUser.where( :chat_id => chat.id, :user_id => chat.users.pluck('users.id').delete_if {|x| x == current_user.id} )
        ChatUser.increment_counter(:unread, chat_users_ids.pluck('chat_users.id'))

        # чаты у всех пользователей с новым сообщением становятся видимыми ( is_hidden = 0 )
        ChatUser.where( :chat_id => chat.id ).each do |c|
          c.update_attribute(:is_hidden, 0)
        end
        puts "my super test"

      end
      #trigger_success mess
    else
      trigger_failure mess
    end
  end

  def destroy

    #puts "destroy message"
    #puts message.inspect()

    my_message = ChatMessage.where( :user_id => current_user.id, :id => message[:id] ).first
    if my_message
      trigger_success my_message
      # уведомление всех пользователей чата о том, что удалено сообщение
      chat = Chat.find(my_message.chat_id)
      if chat
        chat.users.each do |u|
          WebsocketRails["user_#{u.id}"].trigger :destroy_message, my_message
        end
      end

      my_message.destroy
    end

  end

  def remove
    my_message = ChatMessage.where( :user_id => current_user.id, :id => message[:id] ).first
    if my_message
      trigger_success my_message

      my_message.update_attribute(:status, 1)

      # уведомление всех пользователей чата о том, что удалено сообщение
      chat = Chat.find(my_message.chat_id)
      if chat
        chat.users.each do |u|
          WebsocketRails["user_#{u.id}"].trigger :remove_message, my_message
        end
      end


    end
  end

end