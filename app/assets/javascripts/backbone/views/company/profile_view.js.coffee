Beweek3.Views.Company ||= {}

class Beweek3.Views.Company.ProfileView extends Backbone.View

  template: JST["backbone/templates/company/profile"]

  tagName: 'div'
  className: 'main-container layer-block'

  events :
    "change .edit_field" : "update"
    "change .photo_field" : "upload_photo"
    "click #change_tarif_go" : "activate_select"
    "submit #change_plan_form" : "change_plan"

  initialize: ->
    @pay = false
    @model.attributes.can_edit = if aid >= 2 then 1 else 0

  upload_photo: () =>
    @$el.find('#user_photo').ajaxSubmit()

  change_plan: (e) =>
    if !@pay
      e.preventDefault()
      e.stopPropagation()
      type = $('#change_tarif_select').val()
      WS.trigger "ext.payment", {type: type}, (resp) =>
        if resp.success
          $('input[name="OutSum"]').val(resp.price)
          $('input[name="InvId"]').val(resp.bill)
          $('input[name="SignatureValue"]').val(resp.signature)
          @pay = true

          $('#change_plan_form').submit()



  activate_select: (e) ->
    @$el.find('#change_tarif_btn').show()
    @$el.find('#change_tarif_select').removeAttr('disabled').show()
    e.target.remove()

  update : (e) ->
    e.preventDefault()
    e.stopPropagation()
    @model.save()

  render: ->
    $(@el).html(@template(@model.toJSON())).attr 'data-code', 'company'
    this.$el.backboneLink(@model)
    return this