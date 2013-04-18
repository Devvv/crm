Beweek3.Views.Contacts ||= {}

class Beweek3.Views.Contacts.NewUserView extends Backbone.View

  template: JST["backbone/templates/contacts/new_user"]

  tagName: 'div'
  className: 'main-container layers-container layer-block'

  events :
    "keyup #search-name" : "find"

  find : (e) ->
    e.preventDefault()
    e.stopPropagation()

    n = $('#search-name').val()
    c = $('#company_ident').attr "data-id"
    WS.trigger "ext.users", {name: n, company_id: c}, (resp) =>
      if resp.stat == 'success'
        $('#user-list').html('')
        for item in resp.data
          do (item) ->
            get_name = ''
            if item.full_name != item.email
              get_name += ' (' + item.email.replace(new RegExp(n, 'gi'), '<b>' + n + '</b>') + ')'
            $('#user-list').append('<div class="add_new_user_box_send"><img width="70" height="70" style="float:left" src="' + item.photo_path + '" /><p class="name">' + item.full_name.replace(new RegExp(n, 'gi'), '<b>' + n + '</b>') + get_name + '</p><p class="appointment">' + item.appointment + '</p><p class="invite btn btn-invite" data-id="' + item.id + '" data-to="' + item.email + '">Пригласить</p></div>')
      if resp.stat == 'empty'
        $('#user-list').html('')
        if /[0-9a-z_]+@[0-9a-z_^.]+\.[a-z]{2,3}/i.test(n)
          $('#user-list').html('<button class="btn btn-invite" data-to="' + n + '">Пригласить</button>')
      $('#user-list').prepend('<button class="btn btn-add-contact" data-name="' + n + '">Добавить контакт</button><br><br><div class="clear"></div>');
      $('.btn-invite').click ->
        t = $(this)
        WS.trigger "ext.invite", {email: t.attr('data-to'), company_id: c}, (resp) ->
          t.attr("disabled", "disabled")
          t.text(resp.data)
      $('.btn-add-contact').click ->

        t = $(this)
        name = t.attr("data-name")
        md = new Beweek3.Models.Contact({name: name})
        #console.log 'contact add', name
        md.save({}
          success: (contact) ->
            #console.log 'contact add success', contact
            router.contacts.add(contact)
            router.navigate(location.pathname.replace(RegExp('\/u\-new\.?[^\/]*'), "/c-#{contact.id}"), {trigger: true})

          complete: ->
            #console.log 'contact add complete'
        )



      @$el.find('.viewport').mouseEventScroll()
      @$el.find('.filter_block').mouseEventScroll()

  render: ->
    $(@el).html(@template()).attr 'data-code', "u-new"
    return this