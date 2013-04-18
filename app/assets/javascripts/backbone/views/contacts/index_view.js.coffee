Beweek3.Views.Contacts ||= {}

class Beweek3.Views.Contacts.IndexView extends Backbone.View

  template: JST["backbone/templates/contacts/index"]

  tagName: 'div'
  className: 'main-container layer-block'

  initialize: () ->
    @options.users.bind('reset', @addAll)
    @options.contacts.bind('reset', @addAll)

    @options.contacts.bind('add', @addOneContact)

  addAll: () =>
    @options.users.each(@addOneUser)
    @options.contacts.each(@addOneContact)

  addOneUser: (user) =>
    view = new Beweek3.Views.Contacts.UserView({model : user})
    @$("ul").append(view.render().el)

  addOneContact: (contact) =>
    view = new Beweek3.Views.Contacts.ContactView({model : contact})
    @$("ul").append(view.render().el)

  render: =>
    $(@el).html(@template(users: @options.users.toJSON(), contacts: @options.contacts.toJSON() )).attr 'data-code', 'conts'
    @addAll()   

    return this
