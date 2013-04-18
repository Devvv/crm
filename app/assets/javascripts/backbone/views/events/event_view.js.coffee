Beweek3.Views.Events ||= {}

class Beweek3.Views.Events.EventView extends Backbone.View
  template: JST["backbone/templates/events/event"]

  events:
    "click .stason_delete_event_btn" : "delete_event"

  delete_event: ->
    #console.log 'Удаление: ', @model
    @model.destroy()
    #@remove()
    #@model.set('status', 1)
    #class_name = if @model.get('user_id') == uid then "me" else "theirs"
    #$(@el).html(@template(@model.toJSON())).addClass(class_name)

    #WS.trigger 'messages.remove', @model.attributes


  initialize: ->


    #@model.bind('remove', @remove_one)

    ###
    user = _.filter(@options.users, (num) =>
      @model.get('user_id') == num.id
    )[0]
    @model.attributes.user = user

    user = router.users.get( @model.get('user_id') )
    if user
      @model.attributes.user = user
    else
      user = new Beweek3.Models.User()
      user.set "id", @model.get('user_id')
      user.set "name", "noname"
      user.fetch
        success: (user) =>
          console.log user
          @$el.find('.u_avatar').attr('alt', user.get_name())
          @$el.find('.u_avatar').attr('src', user.get('photo_path_thumb'))
          alert 'LooL'

          router.users.add(user)
    ###

    #user = router.users.get(@model.attributes.user_id)
    #@model.attributes.user_name = user.get_name()
    #if @model.attributes.user_to > 0
    #  user_to = router.users.get(@model.attributes.user_to)
    #  if user_to
    #    @model.attributes.user_to_name = user_to.get_name()

  #events:
    #

  tagName: "div"

  className: "menu_event_list"

  remove_one: =>
    #console.log 'remove_one'
    #if message.get('chat_id') == @options.chat.id
    @remove()
    #tmp_el = $('.chat_box .right_column .viewport')
    #tmp_el.tinyscrollbar()
    #tmp_el.tinyscrollbar_update('bottom')


  render: =>
    $(@el).html(@template(@model.toJSON()))
    #console.log @model

    return this
