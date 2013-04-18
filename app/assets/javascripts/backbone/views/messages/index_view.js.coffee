Beweek3.Views.Messages ||= {}

class Beweek3.Views.Messages.IndexView extends Backbone.View

  template: JST["backbone/templates/messages/index"]

  tagName: 'div'
  className: 'right_column' #overview

  initialize: () ->

    #console.log 'Messages IndexView initialize', @options.chat

    # кнопка открываемого чата делается активной
    router.chats.get(@options.chat.id).set_active_btn()


    @options.messages.bind('reset', @addAll)
    router.messages.on('add', @addOne)

    CC[@options.chat.id].bind "create_message", (message) =>
      if parseInt(message.id) > 0

        $.gritter.add(
          title: @options.chat.get_name()
          text: message.text
        )

        router.messages.add(message)

    CC[@options.chat.id].bind "type_text", (message) =>
      console.log 'type_text', message
      if message['user_id'] != uid
        console.log @$el
        console.log @$el.find('.type_text_msg')
        if !@$el.find('.type_text_msg').get(0)
          @$el.find('.overview').append('<div class="type_text_msg">Печатает...</div>')

        #@$el.find('.viewport').tinyscrollbar()
        #@$el.find('.viewport').tinyscrollbar_update('bottom')
        if @$el.find('.overview').height() - (@$el.find('.viewport').scrollTop() + @$el.find('.viewport').height()) < 35
          @$el.find('.viewport').scrollTop( @$el.find('.overview').height() )


        clearTimeout @type_text_timer
        @type_text_timer = setTimeout(
          =>
            @$el.find('.type_text_msg').remove()
          1500
        )




  events:
    "click #chat_message_submit": "submit_click"
    "keypress #chat_message_input": "type_text_event"

  submit_click: (e) ->
    e.preventDefault()
    e.stopPropagation()
    text = @$el.find('#chat_message_input').val()
    if text.length >= 1
      mod = new Beweek3.Models.Message( { text: text, chat_id: @options.chat.id } )
      mod.save()
      #router.messages.create({ text: text, chat_id: @options.chat.id }, { silent: true })
      @$el.find('#chat_message_input').val('')

  type_text_event: (e) =>
    console.log 'type text event'
    WS.trigger "chats.typetext", { chat_id: @options.chat.id }

  addAll: () =>
    @options.messages.each(@addOne)

  addOne: (message) =>
    if message.get('chat_id') == @options.chat.id

      @$el.find('.type_text_msg').remove()

      view = new Beweek3.Views.Messages.MessageView(model : message, users: @options.chat.attributes.users  )
      @$el.find('.overview').append(view.render().el)

      @$el.find('.viewport').scrollTop( @$el.find('.overview').height() )
      #@$el.find('.viewport').tinyscrollbar()
      #@$el.find('.viewport').tinyscrollbar_update('bottom')



      #$('chat_box.left_column.viewport').prepend(view.render().el)



  render: =>
    $(@el).html(@template())
    @addAll()

    return this
