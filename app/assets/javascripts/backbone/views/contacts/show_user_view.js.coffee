Beweek3.Views.Contacts ||= {}

class Beweek3.Views.Contacts.ShowUserView extends Backbone.View

  template: JST["backbone/templates/contacts/show_user"]

  tagName: 'div'
  className: 'main-container layers-container layer-block'

  events :
    #"change .edit_field" : "update"
    "change .photo_field" : "upload_photo"

  initialize: ->
    #@model.on "change", =>
    #CH.bind "update_user_photo", (params) =>
    #  if parseInt(@model.id) == parseInt(params.id)
    #    @model.set "photo_path_medium", params.photo_path_medium
    #    @model.set "photo_path_thumb", params.photo_path_thumb
    #    @$el.find('.person-img img').attr('src', params.photo_path_medium)
    #CH.bind "update_feed", (user) =>
    #  if @model.id == user.id
    #    @model.set user
    #    if $('div[data-code="u-' + @model.id + '"]').get(0)
    #      @render()
    #      @$('.content_block').last().find('.viewport').mouseEventScroll()
    #      @$('.filter_block').last().mouseEventScroll()
    #      @$('.auto_resize').autoResizeTextarea()

  upload_photo: () =>
    @$el.find('#user_photo').ajaxSubmit()

  #update : (e) ->
  #  e.preventDefault()
  #  e.stopPropagation()
  #  @model.save()

  render: ->

    ts = _.union( router.feeds.where({user_id: @model.id, type_id: 1}), router.feeds.where({user_to: @model.id, type_id: 1}))
    ds = _.union( router.feeds.where({user_id: @model.id, type_id: 2}), router.feeds.where({user_to: @model.id, type_id: 2}))
    es = _.union( router.feeds.where({user_id: @model.id, type_id: 3}), router.feeds.where({user_to: @model.id, type_id: 3}))
    dcs = _.union( router.feeds.where({user_id: @model.id, type_id: 4}), router.feeds.where({user_to: @model.id, type_id: 4}))

    $(@el).html(@template(@model.toJSON())).attr 'data-code', "u-#{@model.id}"
    this.$el.backboneLink(@model)

    @$el.find('.ts_count').text(ts.length || "")
    @$el.find('.ds_count').text(ds.length || "")
    @$el.find('.es_count').text(es.length || "")
    @$el.find('.dcs_count').text(dcs.length || "")

    task_view = new Beweek3.Views.Feeds.SubfeedsView(feeds: new Beweek3.Collections.FeedsCollection().reset(ts), type: 1, user_to: @model.id)
    @$el.find('.tab-pane#task').append(task_view.render().el)

    deal_view = new Beweek3.Views.Feeds.SubfeedsView(feeds: new Beweek3.Collections.FeedsCollection().reset(ds), type: 2, user_to: @model.id)
    @$el.find('.tab-pane#deal').append(deal_view.render().el)

    event_view = new Beweek3.Views.Feeds.SubfeedsView(feeds: new Beweek3.Collections.FeedsCollection().reset(es), type: 3, user_to: @model.id)
    @$el.find('.tab-pane#event').append(event_view.render().el)

    docs_view = new Beweek3.Views.Feeds.SubfeedsView(feeds: new Beweek3.Collections.FeedsCollection().reset(dcs), type: 4, user_to: @model.id)
    @$el.find('.tab-pane#docs').append(docs_view.render().el)

    return this