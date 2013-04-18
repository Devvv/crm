Beweek3.Views.Chats ||= {}

class Beweek3.Views.Chats.UserView extends Backbone.View
  template: JST["backbone/templates/chats/user"]

  initialize: ->
    #user = router.users.get(@model.attributes.user_id)
    #@model.attributes.user_name = user.get_name()
    #if @model.attributes.user_to > 0
    #  user_to = router.users.get(@model.attributes.user_to)
    #  if user_to
    #    @model.attributes.user_to_name = user_to.get_name()

  events:
    "click" : "open_chat"

  tagName: "div"

  className: "contacnt_list_user"

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  open_chat: () ->
    mod = new Beweek3.Models.Chat()
    mod.save { name: '', with_id: @model.id }, {
      success: (chat) =>
        window.current_chat = chat.id
        CC[chat.id] = WS.subscribe('chat_' + chat.id)
        CC[chat.id].bind 'open_chat', (chat) =>
          router.chats.add(chat)


        #console.log 'user_view is_hidden set 0', router.chats.get(chat.id)
        router.chats.get(chat.id).set 'is_hidden', 0
        #console.log chat
        #router.chats.add(chat)
        #router.chats.get(chat.id).set 'is_hidden', 0



        data = router.messages.where { chat_id: chat.id }
        messages = new Beweek3.Collections.MessagesCollection()
        messages.reset data

        view = new Beweek3.Views.Messages.IndexView(messages: messages, chat: chat)
        $('.chat_box .right_column').after(view.render().el).remove()

        #$('.chat_box .right_column').find('.viewport').tinyscrollbar()
        #$('.chat_box .right_column').find('.viewport').tinyscrollbar_update('bottom')

        $('.chat_box .right_column').find('.viewport').scrollTop( $('.chat_box .right_column').find('.overview').height() )


        #@$el.parent().find('.chat_box_user').removeClass('active_chat')
        #@$el.addClass('active_chat')

    }


  render: ->
    $(@el).html(@template(@model.toJSON()))
    this