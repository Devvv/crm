Beweek3.Views.Bills ||= {}

class Beweek3.Views.Bills.ShowView extends Backbone.View

  template: JST["backbone/templates/bills/show"]

  tagName: 'div'
  className: 'main-container layers-container layer-block'

  events :
    "change .edit_field" : "update"
    "click .destroy" : "destroy"
    "click .add_position" : "addNew"

  constructor: (options) ->
    super(options)    
    if !("model" of options)
      @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )  

  initialize: -> 

    CH.bind "check_sum", (bill_id) =>
      if @model.id == bill_id
        @model.set "company_id", $('#company_ident').attr('data-id')
        @model.set "user_id", $('#current_user').attr('data-id')
        @model.save()  

    CH.bind "update_bill", (bill) =>
      if @model.id == bill.id
        old = @model.attributes
        @model.set bill
        if $('div[data-code="b-' + @model.id + '"]').get(0)
          if @model.get('can_edit') == old.can_edit
            @model.set_total()
            @$el.backboneViewUpdate(@model, old)            
          else
            @render()      

  addPositions: () =>   
    @options.positions.each(@addPosition)    

  addPosition: (position) =>
    view = new Beweek3.Views.Bills.PositionView({model : position})
    @$el.find('.detail-name.bill-positions').append(view.render().el)

  addNew: () =>    
    if @model.id == "new"
      @saveNew()
      if location.pathname.indexOf('b-new') > -1
        #
      else
        model = new Beweek3.Models.Position({bill_id : @model.id})
        @addPosition(model)  
    else  
      model = new Beweek3.Models.Position({bill_id : @model.id})
      @addPosition(model)

  update : (e) ->
    e.preventDefault()
    e.stopPropagation()    
    attrs = {}
    $(@el).find('.edit_field').each ->      
      attrs[$(this).attr("name")] = $(this).val()            
    @model.set(attrs)     
    
    if @model.id == "new"      
      @saveNew()
    else       
      @model.set "company_id", $('#company_ident').attr('data-id')
      @model.set "user_id", $('#current_user').attr('data-id')
      @model.save()

  saveNew: () =>
    @model.set "company_id", $('#company_ident').attr('data-id')
    @model.set "user_id", $('#current_user').attr('data-id')
    #console.log(@model)
    if @options.parent > 0
      @model.set "feed_id", @options.parent 

    router.bills.create(@model.toJSON(),
      success: (bill) =>
        @model = bill        
        #console.log @model
        router.navigate(location.pathname.replace(RegExp('\/b\-new\.?[^\/]*'), "/b-#{bill.id}"), {trigger: true})

      error: (bill) =>        
        @model.set({errors: bill})        
    )

  destroy: () ->
    e.preventDefault()
    e.stopPropagation()
    @model.destroy()
    this.remove()

    return false

  render: ->
    $(@el).html(@template(@model.toJSON())).attr 'data-code', "b-#{@model.id}"    
    #this.$el.backboneLink(@model)
    @addPositions()    
    return this