Beweek3.Views.Contacts ||= {}

class Beweek3.Views.Contacts.ContactView extends Backbone.View
  template: JST["backbone/templates/contacts/contact"]

  initialize: =>
    @model.attributes.full_name = @model.get_name()

    @model.on 'destroy', @rem

  events:
    "click .destroy" : "destroy"

  tagName: "li"

  className: "event-line layer"

  rem: () =>
    @remove()


  destroy: () =>
    @model.destroy()
    @remove()

    return false

  render: ->
    $(@el).html(@template(@model.toJSON())).attr 'url', "/conts/c-#{@model.id}"
    return this
