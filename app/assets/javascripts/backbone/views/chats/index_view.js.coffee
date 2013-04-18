Beweek3.Views.Chats ||= {}

class Beweek3.Views.Chats.IndexView extends Backbone.View

  template: JST["backbone/templates/chats/index"]

  tagName: 'div'
  className: 'overview'

  initialize: () ->
    @options.chats.bind('reset', @addAll)
    @options.chats.on('add', @addOne)


  addAll: () =>
    @options.chats.each(@addOne)

  addOne: (chat) =>
    if chat.get('is_hidden') == 0
      #console.log 'index_view -> addOne -> new ChatView'
      view = new Beweek3.Views.Chats.ChatView({model : chat})
      @$el.prepend(view.render().el)

    chat.on "change:is_hidden", @is_hidden_set
    #$('chat_box.left_column.viewport').prepend(view.render().el)


  is_hidden_set: (chat) =>
    #console.log 'index_view is_hidden_set, send trigger', chat
    WS.trigger(
      'chats.hide_chat'
      chat.attributes
    )
    #if chat.get('is_hidden') == 1
    #  remove находится в chats_view
    #  chat.remove()

    if chat.get('is_hidden') == 0
      #console.log 'index_view -> is_hidden_set -> new ChatView'
      view = new Beweek3.Views.Chats.ChatView({model : chat})
      @$el.prepend(view.render().el)

  render: =>
    $(@el).html(@template())
    @addAll()

    return this
