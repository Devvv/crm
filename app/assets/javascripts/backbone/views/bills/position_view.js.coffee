Beweek3.Views.Bills ||= {}

class Beweek3.Views.Bills.PositionView extends Backbone.View
  template: JST["backbone/templates/bills/position"]

  events:
    "change .inner_edit_field" : "update"
    "click .destroy" : "destroy"

  tagName: "li"

  className: "event-line layer"

  initialize: ->  

    CH.bind "update_position", (position) =>      
      if @model.id == position.id        
        @model.set position
        @$el.backboneViewUpdate(@model)
        
  update : (e) ->
    e.preventDefault()
    e.stopPropagation()
    attrs = {}
    $(@el).find('.inner_edit_field').each ->            
      attrs[$(this).attr("name")] = $(this).val()            
    @model.set(attrs)   
    @model.set "company_id", $('#company_ident').attr('data-id')
    #@model.set "user_id", $('#current_user').attr('data-id')      
    @model.save()              

  destroy: () ->
    e.preventDefault()
    e.stopPropagation()
    @model.destroy()
    this.remove()

    return false

  render: ->
    $(@el).html(@template(@model.toJSON()))    
    return this