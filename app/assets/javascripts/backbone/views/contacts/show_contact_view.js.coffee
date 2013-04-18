Beweek3.Views.Contacts ||= {}

class Beweek3.Views.Contacts.ShowContactView extends Backbone.View

  template: JST["backbone/templates/contacts/show_contact"]

  tagName: 'div'
  className: 'main-container layers-container layer-block'

  events :
    "click .trash" : "destroy"
    "change .edit_field" : "update"

  initialize: =>
    #@model.on 'destroy', @remove

  destroy: () =>
    #console.log 'contact destroy'
    nav( Beweek3.unlink('c-' + @model.id) )
    @model.destroy()
    @remove()

  update : (e) ->
    e.preventDefault()
    e.stopPropagation()
    @model.save()

  render: ->
    uid = $('#current_user').attr('data-id')
    if @model.attributes.id == uid
      @model.attributes.can_edit = 1
    $(@el).html(@template(@model.toJSON())).attr 'data-code', "c-#{@model.id}"
    if @model.attributes.can_edit == 1
      this.$el.backboneLink(@model)
    return this