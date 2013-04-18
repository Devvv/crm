Beweek3.Views.Feeds ||= {}

class Beweek3.Views.Feeds.SubfeedsView extends Backbone.View

  template: JST["backbone/templates/feeds/subfeeds"]

  initialize: () ->
    if @options.id > 0
      router.feeds.on "add", (feed) =>
        if parseInt(feed.get('feed_id')) == parseInt(@options.id) and parseInt(feed.get("type_id")) == parseInt(@options.type)
          @addOne(feed)
          @countAll()
      router.feeds.on "change:feed_id", (feed) =>
        if parseInt(feed.get('feed_id')) == parseInt(@options.id) and parseInt(feed.get("type_id")) == parseInt(@options.type) and not @options.feeds.where({id: feed.id})[0]
          @addOne(feed)
          @countAll()

  addAll: () =>
    @options.feeds.each(@addOne)

  addOne: (feed) =>
    if @options.id > 0
      view = new Beweek3.Views.Feeds.SubfeedView({model: feed, user_to: @options.user_to, id: @options.id})
      @$el.append(view.render().el)
    if @options.user_to > 0
      view = new Beweek3.Views.Feeds.SubfeedView({model: feed, user_to: @options.user_to, id: @options.id})
      @$el.append(view.render().el)

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

  render: =>
    $(@el).html(@template())
    @addAll()

    return this
