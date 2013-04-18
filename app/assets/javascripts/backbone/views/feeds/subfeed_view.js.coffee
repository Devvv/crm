Beweek3.Views.Feeds ||= {}

class Beweek3.Views.Feeds.SubfeedView extends Backbone.View
  template: JST["backbone/templates/feeds/subfeed"]

  initialize: =>
    if @options.id > 0
      router.feeds.bind "change:feed_id", (feed) =>
        if parseInt(feed.get("feed_id")) != parseInt(@options.id) and parseInt(feed.id) == parseInt(@model.id)
          @countAll()
          @destroy()
    router.feeds.on "remove", (feed) =>
      if parseInt(@model.id) == parseInt(feed.id)
        @countAll()
        @destroy()
    @model.on "change", (feed) =>
      @render()
    @model.on "remove", (feed) =>
      @countAll()
      @destroy()


  events:
    "click .destroy" : "destroy"

  tagName: "div"

  className: "list-line no-bg"

  destroy: () ->
    #@model.destroy()
    @$el.remove()

    return false

  countAll: () =>
    if @options.id > 0
      ts = router.feeds.where({feed_id: @options.id, type_id: 1})
      ds = router.feeds.where({feed_id: @options.id, type_id: 2})
      es = router.feeds.where({feed_id: @options.id, type_id: 3})
      dcs = router.feeds.where({feed_id: @options.id, type_id: 4})
      @$el.parents('.feed_tabs').find('.ts_count').text(ts.length || "")
      @$el.parents('.feed_tabs').find('.ds_count').text(ds.length || "")
      @$el.parents('.feed_tabs').find('.es_count').text(es.length || "")
      @$el.parents('.feed_tabs').find('.dcs_count').text(dcs.length || "")
    if @options.user_to > 0
      ts = _.union( router.feeds.where({user_id: @options.user_to, type_id: 1}), router.feeds.where({user_to: @options.user_to, type_id: 1}))
      ds = _.union( router.feeds.where({user_id: @options.user_to, type_id: 2}), router.feeds.where({user_to: @options.user_to, type_id: 2}))
      es = _.union( router.feeds.where({user_id: @options.user_to, type_id: 3}), router.feeds.where({user_to: @options.user_to, type_id: 3}))
      dcs = _.union( router.feeds.where({user_id: @options.user_to, type_id: 4}), router.feeds.where({user_to: @options.user_to, type_id: 4}))
      @$el.parents('.feed_tabs').find('.ts_count').text(ts.length || "")
      @$el.parents('.feed_tabs').find('.ds_count').text(ds.length || "")
      @$el.parents('.feed_tabs').find('.es_count').text(es.length || "")
      @$el.parents('.feed_tabs').find('.dcs_count').text(dcs.length || "")

  render: ->
    $(@el).html(@template(@model.toJSON()))
    return this
