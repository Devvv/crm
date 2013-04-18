Beweek3.Views.Chats ||= {}

class Beweek3.Views.Chats.ChatView extends Backbone.View
  template: JST["backbone/templates/chats/chat"]

  initialize: ->
    #console.log 'ChatView initialize'
    @model.on "change:unread", @unread_set
    @model.on "change:is_hidden", @is_hidden_set

    @model.on "change:tmp_counter", @set_active_btn

    #user = router.users.get(@model.attributes.user_id)
    #@model.attributes.user_name = user.get_name()
    #if @model.attributes.user_to > 0
    #  user_to = router.users.get(@model.attributes.user_to)
    #  if user_to
    #    @model.attributes.user_to_name = user_to.get_name()

  events:
    "click .hide_btn" : "on_hide_chat"
    "click" : "open_messages"

  tagName: "div"

  className: "chat_box_user"

  on_hide_chat: () =>
    @model.set('is_hidden', 1)
    #console.log 'hide_chat', @model



  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  unread_set: () =>
    if window.current_chat == @model.id
      if @model.get('unread') > 0
        @model.set 'unread', 0
        WS.trigger 'chats.reading', @model.attributes

    bumbum = @$el.find('.chat_unread_bumbum')
    bumbum.text( @model.get('unread') )
    if @model.get('unread') > 0
      bumbum.show()
    else
      bumbum.hide()

    chat_summary = 0
    router.chats.each (chat111) ->
      chat_summary += chat111.get('unread')
      #console.log 'chat unread count: ', chat111.get('unread') , chat111
    summary_out = $('#stason_chat_count_summary')
    summary_out.text(chat_summary)
    if chat_summary == 0
      summary_out.hide()
    else
      summary_out.show()

  is_hidden_set: () =>
    #console.log 'chats_view is_hidden_set', @model
    if @model.get('is_hidden') == 1
      @remove()
    #if @model.get('is_hidden') == 0 # render находится в index_view
    #  @render()


  open_messages: () =>
    data = router.messages.where {chat_id: @model.id}

    window.current_chat = @model.id
    #@model.set 'unread', 0
    WS.trigger 'chats.reading', @model.attributes, (el) =>
      chat = router.chats.get(el.id)
      if chat
        chat.set 'unread', 0

      $(@el).find('.chat_unread_bumbum').hide()

    messages = new Beweek3.Collections.MessagesCollection()
    messages.reset data

    @view = new Beweek3.Views.Messages.IndexView(messages: messages, chat: @model)
    $('.chat_box .right_column').after(@view.render().el).remove()

    $('.chat_box .right_column').find('.viewport').scrollTop( $('.chat_box .right_column').find('.overview').height() )

    #$('.chat_box .right_column').find('.viewport').tinyscrollbar()
    #$('.chat_box .right_column').find('.viewport').tinyscrollbar_update('bottom')
    #console.log 'height: ', @$el
    #@$el.find('.viewport').scrollTop( @$el.find('.overview').height() )


    @$el.parent().find('.chat_box_user').removeClass('active_chat')
    @$el.addClass('active_chat')

  set_active_btn: (_chat)=>
    #console.log 'chats_view -> set_active_btn', _chat
    @$el.parent().find('.chat_box_user').removeClass('active_chat')
    @$el.addClass('active_chat')

  render: ->
    $(@el).html(@template(@model.toJSON()))
    return this
