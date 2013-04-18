Beweek3.Views.Calendar ||= {}

class Beweek3.Views.Calendar.EventView extends Backbone.View
  template: JST["backbone/templates/calendar/event"]

  events:
    "click .destroy" : "destroy"

  tagName: "li"

  className: "event-line layer"

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    $(@el).html(@template(@model.toJSON())).attr 'url', "/calendar/c-#{@model.id}"
    return this
