#= require_self
#= require_tree ./locales
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

# Заглушка для картинок
window.thumb_null = "/photos/medium/missing.png"

Backbone.sync = (method, model, options) ->
  #console.log model.url().match(/\w+/)[0] + "." + method, model, options
  model.trigger "sync:start"
  WS.trigger model.url().match(/\w+/)[0] + "." + method, model.attributes || model,
    (data) ->
      options.success(data) if typeof options.success == "function"
      options.complete(data) if typeof options.complete == "function"
    (data) ->
      options.error(data) if typeof options.error == "function"
      options.complete(data) if typeof options.complete == "function"
  model.trigger "sync:end"

window.FC =
  0: "post"
  1: "task"
  2: "deal"
  3: "event"
  4: "doc"

window.file_slicer = (file) ->
  @slice_size = 16384
  @slices = Math.ceil(file.size / @slice_size)
  @current_slice = 0;
  @get_next = () =>
    start = @current_slice * @slice_size
    end = Math.min((@current_slice + 1) * @slice_size, file.size)
    ++@current_slice
    if typeof file.slice == "function"
      file.slice(start, end)
    else if typeof file.mozSlice == "function"
      file.mozSlice(start, end)
    else if typeof file.webkitSlice == "function"
      file.webkitSlice(start, end)
  this

window.cancelled = false
$('.cancel-upload').live "click", ->
  file = $(this).attr("data-file")
  console.log "cancel " + file
  window.cancelled = true
  WS.trigger "ext.cancel_upload", {name: file}

window.Beweek3 =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}

  tolink: (url) ->
    if location.pathname.indexOf(url) > -1
      #location.pathname.replace(new RegExp("\/?"+url), '')
    else
      if location.pathname.substr(-1, 0) == "/"
        location.pathname + url
      else
        location.pathname + "/" + url

  unlink: (url) ->
    location.pathname.replace("/"+url, '')

  todate: (date, format = true) ->
    today = new Date(date)
    if format
      ('0' + today.getDate()).slice(-2) + "." + ('0' + (1+today.getMonth())).slice(-2) + "." + ('000' + today.getFullYear()).slice(-2) + " " + ('0' + today.getHours()).slice(-2) + ":" + ('0' + today.getMinutes()).slice(-2)
    else
      ('0' + today.getDate()).slice(-2) + "." + ('0' + (1+today.getMonth())).slice(-2) + "." + ('000' + today.getFullYear()).slice(-4)

  get_start: ->
    today = new Date()
    ('0' + today.getDate()).slice(-2) + "." + ('0' + (1+today.getMonth())).slice(-2) + "." + ('000' + today.getFullYear()).slice(-4) + " " + ('0' + today.getHours()).slice(-2) + ":" + ('0' + today.getMinutes()).slice(-2)

  get_end: ->
    today = new Date()
    tomorrow = new Date( today.getTime() + 3600000 )
    ('0' + tomorrow.getDate()).slice(-2) + "." + ('0' + (1+tomorrow.getMonth())).slice(-2) + "." + ('000' + tomorrow.getFullYear()).slice(-4) + " " + ('0' + tomorrow.getHours()).slice(-2) + ":" + ('0' + tomorrow.getMinutes()).slice(-2)


# функция для открытия окна чата by stason33
window.show_chat_box = ->
  $('.chat_block').show()
  $('.chat_block').addClass('active_chat')
  $('#stason_chat_btn').addClass('active')

# функция для скрытия окна чата by stason33
# при закрытии чата переменная current_chat устанавливается в -1, т.к. все чаты закрыты
window.hide_chat_box = ->
  window.current_chat = -1
  $('.chat_block').hide()
  $('.chat_block').removeClass('active_chat')
  $('#stason_chat_btn').removeClass('active')

window.nav = (hr, e, th, trigger = true) ->
  if e and (hr == undefined or hr.indexOf('#') > -1 or hr == "javascript:;" or hr == "javascript: ;" or hr == "javascript:void(0);" or hr == "javascript:void(0)")
    e.preventDefault()
    false
  else
    if th and th.hasClass('link')
      #
    else

      if hr.substr(0, 1) == "/"
        router.navigate(hr, {trigger: trigger})
      else
        current = location.pathname
        if current.indexOf(hr) > -1
          #
        else
          next = (current + "/" + hr).replace("//", "/")
          router.navigate(next, {trigger: trigger})
      false

window.current_chat = -1

$ ->

  $('.navbar-inner').mouseEventScroll()

  $('*[url]').live 'click', (e) ->
    nav($(this).attr('url'), e, $(this))

  $('a').live 'click', (e) ->
    nav($(this).attr('href'), e, $(this))

  $('a[data-action="close_layer"]').live 'click', (e) ->
    c = $(this).parents('.layer-block').attr("data-code")
    if location.pathname.split('/').length <= 3
      trigger = true
    else
      trigger = false
    cu = new RegExp('\/' + c + '\.?[^\/]*')
    nav(location.pathname.replace(cu , ''), e, $(this), trigger)
    $(this).parents('.layer-block').remove()

  $('ul.nav.nav-tabs li a').live 'click', (e) ->
    tab = $(this).attr('href').replace '#', ''
    html = $(this).parents('.layer-block')
    win = html.attr 'data-code'
    cur = new RegExp('(\/' + win + ')\.?[^\/]*')
    mtc = location.pathname.match(cur)[1]
    if tab != ""
      router.navigate(location.pathname.replace(cur , mtc + "." + tab), {trigger: false})
      html.find('.nav-tabs li').removeClass('active')
      html.find('a[href="#' + tab + '"]').parents('li').addClass('active')
      html.find('.tab-content .tab-pane').removeClass('active')
      html.find('.tab-pane[id="' + tab + '"]').addClass('active')
    else
      router.navigate(location.pathname.replace(cur , mtc), {trigger: false})
      html.find('.nav-tabs li').removeClass('active')
      html.find('a[href="#"]').parents('li').addClass('active')
      html.find('.tab-content .tab-pane').removeClass('active')
      html.find('.tab-pane[id="history"]').addClass('active')


  $('.del_file').live 'click', ->
    id = $(this).attr "data-id"
    th = $(this)
    if id > 0
      WS.trigger "ext.delete_file", {id: id}
      ###
      $.ajax(
        url: "/ajax/file_del"
        type: "post"
        data: {id: id}
        success: (resp) ->
          if resp.stat == "success"
            th.parent().remove()
            $('#store_count').text(resp.count)
          else
            alert resp.data
      )
      ###

  # скрипты для чата
  $('#stason_chat_btn').click ->
    if $('.chat_block').hasClass('active_chat')
      hide_chat_box()
    else
      show_chat_box()

  $('#chat_close_btn').click ->
    hide_chat_box()


  $('#stason_contact_list').click ->
    #$('.chat_box .left_column').find('.chat_box_user').removeClass('active_chat')
    if $('.all_contacts_btn').hasClass('show') and false # <- Кто поставил этот FALSE ???
      $('.all_contacts_btn').removeClass('show')
      $('.message_user_list').hide()
      $('.all_contacts').hide()
    else
      @view = new Beweek3.Views.Chats.UsersView(users: router.users)
      # $('.all_contacts').html(@view.render().el)
      $('.chat_box .right_column').after(@view.render().el).remove()

      $('.all_contacts_btn').addClass('show')
      #$('.message_user_list').hide()
      $('.all_contacts').show()


      #$('.right_column').find('.viewport').tinyscrollbar()
      #$('.right_column').find('.viewport').tinyscrollbar_update('bottom')

    false
  $('#left_menu_btn').bind 'click', ->
    _t = $(this)
    if _t.hasClass('active') == true
      _t.removeClass 'active'
      $('.nav_left_menu').width 0
      $('.container-fluid').css 'left', 0

    else
      _t.addClass 'active'
      $('.nav_left_menu').width 250
      $('.container-fluid').css 'left', 250

  $.extend $.gritter.options,
    position: "bottom-left" # defaults to 'top-right' but can be 'bottom-left', 'bottom-right', 'top-left', 'top-right' (added in 1.7.1)
    fade_in_speed: "medium" # how fast notifications fade in (string or int)
    fade_out_speed: 2000 # how fast the notices fade out
    time: 6000 # hang on the screen for...

  ###
  $('.slide_drop').bind 'click', ->
    el = $(this).find('.company_slide')
    if el.hasClass('open') == false
      el.addClass('open')
    else
      el.removeClass('open')
  ###
  

  # обработчик кликов на чекбоксы. Должен вызываться раньше, чем аналогичные из /templates
  # !!!!!!!!!!!!! stason33:
  # !!!!!!!!!!!!! MOUSEUP не убирать!
  # !!!!!!!!!!!!!    |
  # !!!!!!!!!!!!!    |
  # !!!!!!!!!!!!!    v
  $(document).on 'mouseup', '.filter-line',  ->
    _t = $(this)
    _el = _t.children('.checkbox-filter.custom_checkbox').first()     
    #if _t.data('type') == 'all'
    #  if _el.hasClass('active') == false
    #    _el.addClass 'active'
    #  _.each _t.siblings(), (el, ind, list)->
    #    _child = $(el).children('.checkbox-filter.custom_checkbox').first()
    #    if _child.hasClass('active') == true
    #      _child.removeClass 'active'
    #else
    if _el.hasClass('active') == false
      _el.addClass 'active'
      #_all = _t.siblings("[data-type='all']")
      #_all_child = _all.children('.checkbox-filter.custom_checkbox').first()
      #if _all_child.hasClass('active') == true
      #  _all_child.removeClass 'active'
    else
      _el.removeClass 'active'