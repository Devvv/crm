Beweek3.Views.Contacts ||= {}

class Beweek3.Views.Contacts.UserView extends Backbone.View
  template: JST["backbone/templates/contacts/user"]

  initialize: =>
    @model.attributes.full_name = @model.get_name()

  events:
    "click .destroy" : "destroy"
    "change .history-filter" : "filterHistory"

  tagName: "li"

  className: "event-line layer"

  filterHistory: ->
    if @$el.find('.history-filter').is(':checked')
      @$el.find('#histories .history-block[data-type!=0]').hide()
    else
      @$el.find('#histories .history-block[data-type!=0]').show()
    @$el.find('.content_block').find('.viewport').mouseEventScroll()

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    $(@el).html(@template(@model.toJSON())).attr 'url', "/conts/u-#{@model.id}"
    return this
