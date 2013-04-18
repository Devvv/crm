class Beweek3.Routers.AppRouter extends Backbone.Router

  initialize: (options) ->

    # init collections
    @feeds = new Beweek3.Collections.FeedsCollection()
    @feeds.reset options.feeds
    @users = new Beweek3.Collections.UsersCollection()
    @users.reset options.users
    @contacts = new Beweek3.Collections.ContactsCollection()
    @contacts.reset options.contacts
    @histories = new Beweek3.Collections.HistoriesCollection()
    @histories.reset options.histories
    @bills = new Beweek3.Collections.BillsCollection()
    @bills.reset options.bills
    @positions = new Beweek3.Collections.PositionsCollection()
    @positions.reset options.positions
    @companies = new Beweek3.Collections.CompaniesCollection()
    @companies.reset options.companies
    @chats = new Beweek3.Collections.ChatsCollection()
    @chats.reset options.chats
    @messages = new Beweek3.Collections.MessagesCollection()
    @messages.reset options.messages
    @my_events = new Beweek3.Collections.EventsCollection()
    @my_events.reset options.my_events

    @histories.comparator = (el) =>
      -el.get('id')


    # websocket connection
    if options.mode == "production"
      # production is ssl
      window.WS = new WebSocketRails(location.host + ":3000/ws")
    else
      window.WS = new WebSocketRails(location.host + "/ws")

    #WS.trigger('websocket_rails.reload!');

    window.CH = WS.subscribe('company_' + cid)

    WS.on_open = (data) ->
      #console.log data

    WS.on_close = (data) ->
      $.gritter.add {
        title: "Ошибка соединения с сервером"
        text: "Соединение с сервером разорвано, переподключение..."
      }

    WS.on_error = (data) ->
      $.gritter.add {
        title: "Ошибка соединения с сервером"
        text: "Соединение с сервером разорвано, переподключение..."
      }

    CH.bind "upload_file", (data) =>
      mod = @feeds.get(data.feed_id)
      files_array = mod.get('files')
      files_array ||= {}
      files_array[data.id] = data
      mod.set('files', files_array)
      mod.trigger('change:files')

    CH.bind "update_store", (data) ->
      $('#store_count').text data.store_count
      $('#store_limit').text data.store_limit

    CH.bind "create_contact", (contact) =>
      @contacts.add(contact)

    CH.bind "destroy_contact", (contact) =>
      if @contacts.get(contact.id)
        @contacts.get(contact.id).destroy()
        nav( Beweek3.unlink('c-' + contact.id) )

    # bindings websocket events
    CH.bind "create_feed", (feed) =>
      if !@feeds.get(feed.id) and (parseInt(feed.user_id) == uid or feed.user_to == uid or _.indexOf(feed.refers, uid) > -1)
        @feeds.add(feed)
    CH.bind "destroy_feed", (feed) =>
      if @feeds.get(feed.id)
        @feeds.get(feed.id).destroy()
        nav( Beweek3.unlink('f-' + feed.id) )




    CH.bind "update_feed", (feed) =>
      feed.can_edit = if (aid >= 2 || parseInt(feed.user_id) == uid || parseInt(feed.user_to) == uid) then 1 else 0
      if !@feeds.get(feed.id) and (parseInt(feed.user_id) == uid or feed.user_to == uid or _.indexOf(feed.refers, uid) > -1)
        @feeds.add(feed)
      if @feeds.get(feed.id) and (aid < 2 and parseInt(feed.user_id) != uid and parseInt(feed.user_to) != uid and _.indexOf(feed.refers, uid) == -1)
        @feeds.remove(feed)
      if @feeds.get(feed.id)
        f = @feeds.get(feed.id)
        f.set feed
    CH.bind "update_user", (user) =>
      if @users.get(user.id)
        u = @users.get(user.id)
        u.set user
    CH.bind "add_history", (history) =>
      @histories.add(history)
      #console.log 'add_history', history
      if history.type_id == 0 # если добавлен комментарий, то увеличиваем счетчик комментариев у фида
        feed = router.feeds.get(history.feed_id)
        feed.set('comments', feed.get('comments') + 1)


    # creating channels for chats
    window.CC = {}
    chat_summary = 0
    @chats.each (chat) ->
      CC[chat.id] = WS.subscribe('chat_' + chat.id)
      chat_summary += chat.get('unread')
    summary_out = $('#stason_chat_count_summary')
    summary_out.text(chat_summary)
    if chat_summary == 0
      summary_out.hide()

    window.CU = WS.subscribe("user_" + uid )

    CU.bind "destroy_message", (message) =>
      #console.log "destroy_message"
      if @messages.get(message.id)
        @messages.remove(message)

    CU.bind "remove_message", (message) =>
      #console.log "remove_message"
      my_message = @messages.get(message.id)
      if my_message
        my_message.set('status', message.status)
        my_message.set('text', '')
      #@messages.get(message.id).render()
      #if @messages.get(message.id)
      #  @messages.remove(message)

    view = new Beweek3.Views.Chats.IndexView(chats: @chats)
    $('.chat_box .left_column .viewport').html(view.render().el)

    CU.bind 'new_chat_message', (message) =>
      if parseInt(message.id) > 0

        ch = router.chats.get(message.chat_id)

        if ch

          ch.set('unread', ch.get('unread')+1)
          ch.set 'is_hidden', 0

          if window.current_chat != ch.id
            $.gritter.add(
              title: ch.get_name()
              text: message.text
              after_open: (e) =>
                $(e).attr 'chat_id', ch.id
                $(e).click ->
                  window.show_chat_box()

                  chat_id = $(e).attr 'chat_id'
                  chat = router.chats.get chat_id

                  view = new Beweek3.Views.Chats.ChatView({model : chat})
                  view.open_messages()

                  $(e).remove()
            )

        router.messages.add(message)

    CU.bind 'open_chat', (chat) =>

      #chat_mod = new Beweek3.Models.Chat()
      #chat_mod.set chat

      #$.gritter.add(
      #  title: "New chat"
      #  text: chat_mod.get_name()
      #)

      #console.log 'new chat', chat
      @chats.add(chat)
      CC[chat.id] = WS.subscribe('chat_' + chat.id)

    CU.bind 'new_event', (event) =>

      @my_events.add(event)

      # вывод уведомления
      text = ""
      my_feed = router.feeds.get(event.feed_id)
      if my_feed
        text = my_feed.get('name')

      #open_element = $(".main-container.layers-container.layer-block[data-code=f-" + my_feed.id + "]")
      #console.log 'opened_element', open_element.attr('data-code')

      title = ""
      if event.event_type == 1 # задачи
        title = "Задача"
      else if event.event_type == 2 # сделки
        title = "Сделка"
      else if event.event_type == 3 # события
        title = "Событие"
      else if event.event_type == 4 # документы
        title = "Документ"

      $.gritter.add(
        title: title
        text: text
        after_open: (e) =>
          $(e).attr 'feed_id', my_feed.id
          $(e).click ->
            feed_id = $(e).attr 'feed_id'
            feed = router.feeds.get feed_id

            nav('f-' + feed.id)

            $(e).remove()
      )




  routes:
    "*path"        : "init"

  index: ->
    hide_chat_box()
    $('.company_slide').removeClass('open')
    $('.nav li').removeClass('active')
    $('a[href="/events"]').parents('li').addClass('active')
    @view = new Beweek3.Views.Feeds.IndexView(feeds: @feeds)
    html = @view.render().$el
    $("#content").html(html)
    html.find('.content_block').find('.viewport').mouseEventScroll()
    html.find('.filter_block').mouseEventScroll()

  events: ->
    @index()

  conts: ->
    hide_chat_box()
    $('.company_slide').removeClass('open')
    $('.nav li').removeClass('active')
    $('a[href="/conts"]').parents('li').addClass('active')
    @view = new Beweek3.Views.Contacts.IndexView(users: @users, contacts: @contacts)
    html = @view.render().$el
    $("#content").html(html)
    html.find('.content_block').find('.viewport').mouseEventScroll()
    html.find('.filter_block').mouseEventScroll()

  tasks: ->
    hide_chat_box()
    $('.company_slide').removeClass('open')
    $('.nav li').removeClass('active')
    $('a[href="/tasks"]').parents('li').addClass('active')
    ts = @feeds.where {type_id: 1}
    tasks = new Beweek3.Collections.FeedsCollection()
    tasks.reset ts
    @view = new Beweek3.Views.Tasks.IndexView(tasks: tasks)
    html = @view.render().$el
    $("#content").html(html)
    html.find('.content_block').find('.viewport').mouseEventScroll()
    html.find('.filter_block').mouseEventScroll()

    # удаление уведомлений - перенесено в f: ->
    #_.each(@my_events.where( { event_type: 1 }), (ev) =>
    #  ev.destroy()
    #)

  deals: ->
    hide_chat_box()
    $('.company_slide').removeClass('open')
    $('.nav li').removeClass('active')
    $('a[href="/deals"]').parents('li').addClass('active')
    ds = @feeds.where {type_id: 2}
    deals = new Beweek3.Collections.FeedsCollection()
    deals.reset ds
    @view = new Beweek3.Views.Deals.IndexView(deals: deals)
    html = @view.render().$el
    $("#content").html(html)
    html.find('.content_block').find('.viewport').mouseEventScroll()
    html.find('.filter_block').mouseEventScroll()

    # удаление уведомлений - перенесено в f: ->
    #_.each(@my_events.where( { event_type: 2 }), (ev) =>
    #  ev.destroy()
    #)

  docs: ->
    hide_chat_box()
    $('.company_slide').removeClass('open')
    $('.nav li').removeClass('active')
    $('a[href="/docs"]').parents('li').addClass('active')
    #ds = @feeds.where {type_id: 4}
    #docs = new Beweek3.Collections.FeedsCollection()
    #docs.reset ds
    @view = new Beweek3.Views.Docs.IndexView(docs: @feeds)
    html = @view.render().$el
    $("#content").html(html)
    html.find('.content_block').find('.viewport').mouseEventScroll()
    html.find('.filter_block').mouseEventScroll()

    # удаление уведомлений - перенесено в f: ->
    #_.each(@my_events.where( { event_type: 4 }), (ev) =>
    #  ev.destroy()
    #)

  calendar: ->
    hide_chat_box()
    $('.company_slide').removeClass('open')
    $('.nav li').removeClass('active')
    $('a[href="/calendar"]').parents('li').addClass('active')
    es = @feeds.where {type_id: 3}
    events = new Beweek3.Collections.FeedsCollection()
    events.reset es
    @view = new Beweek3.Views.Calendar.IndexView(items: events)
    @view.render()
    #$('.content_block').last().find('.viewport').mouseEventScroll()
    #$('.filter_block').last().mouseEventScroll()

    # удаление уведомлений - перенесено в f: ->
    #_.each(@my_events.where( { event_type: 3 }), (ev) =>
    #  ev.destroy()
    #)


  f: (id, tab, parent = 0, user_to = 0) ->
    if id == "new"
      @view = new Beweek3.Views.Feeds.NewView(collection: @feeds, type: tab, parent: parent, user_to: user_to)
      html = @view.render().$el
      $("#content").append(html)
      html.find('.auto_resize').autoResizeTextarea()
      html.updateLayers()
    else
      feed = @feeds.get(id)
      if feed
        @view = new Beweek3.Views.Feeds.ShowView(model: feed)

        #console.log feed
        # удаление уведомлений, привязанных к открываемому feed'у
        _.each(@my_events.where( { feed_id: feed.id }), (ev) =>
          ev.destroy()
        )

        html = @view.render().$el
        if tab
          html.find('.nav-tabs li').removeClass('active')
          html.find('a[href="#' + tab + '"]').parents('li').addClass('active')
          html.find('.tab-content .tab-pane').removeClass('active')
          html.find('.tab-pane[id="' + tab + '"]').addClass('active')
        $("#content").append(html)
        html.updateDetail().updateLayers()
      else
        @["404"]()

  u: (id, tab) ->
    if id > 0
      user = @users.get(id)
      if user
        @view = new Beweek3.Views.Contacts.ShowUserView(model: user)
        html = @view.render().$el
        if tab
          html.find('.nav-tabs li').removeClass('active')
          html.find('a[href="#' + tab + '"]').parents('li').addClass('active')
          html.find('.tab-content .tab-pane').removeClass('active')
          html.find('.tab-pane[id="' + tab + '"]').addClass('active')
      else
        @["404"]()
    else
      @view = new Beweek3.Views.Contacts.NewUserView()
      html = @view.render().$el
    $("#content").append(html)
    if $('.layers-container').size() == 1
      $('.layers-container').css {left: 10 + '%', zIndex: 100}
    else
      $('.layers-container').each (i, n) ->
        $(n).css {left: 5 + ((i + 1) * 5) + '%', zIndex: (i + 1) * 100}
    html.find('.content_block').find('.viewport').mouseEventScroll()
    html.find('.filter_block').mouseEventScroll()
    html.find('.auto_resize').autoResizeTextarea()

  c: (id, tab) ->
    contact = @contacts.get(id)
    if contact
      @view = new Beweek3.Views.Contacts.ShowContactView(model: contact)
      html = @view.render().$el
      if tab
        html.find('.nav-tabs li').removeClass('active')
        html.find('a[href="#' + tab + '"]').parents('li').addClass('active')
        html.find('.tab-content .tab-pane').removeClass('active')
        html.find('.tab-pane[id="' + tab + '"]').addClass('active')
      $("#content").append(html)
      if $('.layers-container').size() == 1
        $('.layers-container').css {left: 10 + '%', zIndex: 100}
      else
        $('.layers-container').each (i, n) ->
          $(n).css {left: 5 + ((i + 1) * 5) + '%', zIndex: (i + 1) * 100}
      html.find('.content_block').find('.viewport').mouseEventScroll()
      html.find('.filter_block').mouseEventScroll()
      #html.find('.auto_resize').autoResizeTextarea()
    else
      @["404"]()

  b: (id, tab, parent = 0) ->
    if id == "new"
      bill_positions = new Beweek3.Collections.PositionsCollection()
      @view = new Beweek3.Views.Bills.ShowView(collection: @bills, positions: bill_positions, parent: parent)
      html = @view.render().$el
      $("#content").append(html)
      html.find('.auto_resize').autoResizeTextarea()
    else
      bill = @bills.get(id)
      if bill
        bill.set_total()
        ps = @positions.where {bill_id: parseInt(id)}
        bill_positions = new Beweek3.Collections.PositionsCollection()
        bill_positions.reset ps
        @view = new Beweek3.Views.Bills.ShowView(model: bill, positions: bill_positions)
        html = @view.render().$el
        if tab
          html.find('.nav-tabs li').removeClass('active')
          html.find('a[href="#' + tab + '"]').parents('li').addClass('active')
          html.find('.tab-content .tab-pane').removeClass('active')
          html.find('.tab-pane[id="' + tab + '"]').addClass('active')
        $("#content").append(html)
        html.find('.content_block').find('.viewport').mouseEventScroll()
        html.find('.filter_block').mouseEventScroll()
        html.find('.auto_resize').autoResizeTextarea()
        html.find(".chosen").chosen()
        html.find('.data_change_time').each ->
          $(this).dPicker(
            sdvLe: -66
            sdvTop: 0
            TimeShow: true
          )
        html.find('[data-toggle]').filter_dropdown
          elClick: $(this),
          action: (o) ->
            if o.t.attr('data-toggle') == '#importance_layer'
              $('#importance_layer:visible li a').unbind('click')
              $('#importance_layer:visible li a').bind 'click', ->
                z = $(this).attr('data-imp')
                t =  $(this).text()
                html.find('.importance').find('span').text(t).attr('data-imp', z)
                html.find('.importance').find('input').val(z).trigger('change')
                $('.dropdown-menu').hide()
            if o.t.attr('data-toggle') == '#status_layer'
              $('#status_layer:visible li a').unbind('click')
              $('#status_layer:visible li a').bind 'click', ->
                z = $(this).attr('data-sts')
                t =  $(this).text()
                html.find('.status').find('span').text(t).attr('data-sts', z)
                html.find('.status').find('input').val(z).trigger('change')
                $('.dropdown-menu').hide()
      else
        @["404"]()
    if $('.layers-container').size() == 1
      $('.layers-container').css {left: 10 + '%', zIndex: 100}
    else
      $('.layers-container').each (i, n) ->
        $(n).css {left: 5 + ((i + 1) * 5) + '%', zIndex: (i + 1) * 100}

  profile: (tab) ->
    $('.company_slide').removeClass('open')
    $('.nav li').removeClass('active')
    $('a[href="/profile"]').parents('li').addClass('active')
    user = @users.get(uid)
    @view = new Beweek3.Views.Profile.ProfileView(model: user)
    html = @view.render().$el
    $('#content').html(html)
    html.find('.auto_resize').autoResizeTextarea()
    if tab
      html.find('.nav-tabs li').removeClass('active')
      html.find('a[href="#' + tab + '"]').parents('li').addClass('active')
      html.find('.tab-content .tab-pane').removeClass('active')
      html.find('.tab-pane[id="' + tab + '"]').addClass('active')

  company: (tab) ->
    $('.nav li').removeClass('active')
    $('a[href="/company"]').parents('li').addClass('active')
    $('.company_slide').addClass('open')
    company = @companies.get(cid)
    @view = new Beweek3.Views.Company.ProfileView(model: company)
    html = @view.render().$el
    $('#content').html(html)
    html.find('.auto_resize').autoResizeTextarea()
    if tab
      html.find('.nav-tabs li').removeClass('active')
      html.find('a[href="#' + tab + '"]').parents('li').addClass('active')
      html.find('.tab-content .tab-pane').removeClass('active')
      html.find('.tab-pane[id="' + tab + '"]').addClass('active')

  404: ->
    $("#content").html("404: Not found")

  init: (path) ->
    layers = []
    if path != ""
      parts = path.split('/')
      for part in parts
        do (part, _i) =>
          layer = part.match(/^([a-z\-0-9]+)/)[1]
          layers.push layer
          if part != "" and !$('.layer-block[data-code="'+layer+'"]').get(0)
            if part.indexOf('-') > -1
              segm = part.split('-')
              if typeof @[segm[0]] == "function"
                if segm[1].indexOf('.') > -1
                  ind = segm[1].split('.')
                  tab = ind.splice(1, 1)
                  if tab[0].indexOf('!') > -1
                    ls = tab[0].split('!')
                    @[segm[0]](ind[0], ls[0], ls[1])
                  else if tab[0].indexOf('?') > -1
                    us = tab[0].split("?")
                    @[segm[0]](ind[0], us[0], 0, us[1])
                  else
                    @[segm[0]](ind[0], tab[0])
                else
                  @[segm[0]](segm[1])
              else
                @['404']()
            else
              if part.indexOf('.') > -1
                ind = part.split('.')
                tab = ind.splice(1, 1)
                if typeof @[ind[0]] == "function"
                  @[ind[0]](tab[0])
                else
                  @['404']()
              else
                if typeof @[part] == "function"
                  @[part]()
                else
                  @['404']()

      if layers
        $('.layer-block').each ->
          code = $(this).attr('data-code')
          if _.indexOf(layers, code) == -1
            $(this).remove()
        if $('.layers-container').size() == 1
          $('.layers-container').css {left: 10 + '%', zIndex: 100}
        else
          $('.layers-container').each (i, n) ->
            $(n).css {left: 5 + ((i + 1) * 5) + '%', zIndex: (i + 1) * 100}

    else
      @['index']()

