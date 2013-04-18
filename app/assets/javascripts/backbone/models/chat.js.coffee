class Beweek3.Models.Chat extends Backbone.Model
  paramRoot: 'chat'
  url: ->
    'chats'

  get_name_by_users: =>
    chonibud = []
    for u in @get('users')
      if u.id != uid
        chonibud.push(u.email)
    chonibud.join(', ')

  get_name: =>
    if @get('name')
      if @get('name') == ""
        @get_name_by_users()
      else
        @get('name')
    else
      @get_name_by_users()

  get_img: =>
    chonibud = []
    for u in @get('users')
      if u.id != uid
        chonibud.push(u)
    if chonibud.length == 1
      chonibud[0].photo_path_thumb
    else
      window.thumb_null

  set_active_btn: =>
    #console.log 'model -> set_active_btn'
    @set('tmp_counter', @get('tmp_counter') + 1 )


  defaults:
    id: 'new'
    user_id: ''
    name: ''
    with_id: ''
    tmp_counter: 0

class Beweek3.Collections.ChatsCollection extends Backbone.Collection
  model: Beweek3.Models.Chat
  url: 'chats'
