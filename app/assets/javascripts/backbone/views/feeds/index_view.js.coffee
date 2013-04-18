Beweek3.Views.Feeds ||= {}

class Beweek3.Views.Feeds.IndexView extends Backbone.View

  filtered = false

  filter_map = {"post": 0,"task": 1,"deal": 2,"event": 3, "doc": 4}  

  template: JST["backbone/templates/feeds/index"]

  tagName: 'div'
  className: 'main-container layer-block'

  events :
    "click .filter-line" : "filterItems"   

  initialize: () ->
    @options.feeds.on 'reset', @addAll
    @options.feeds.on 'add', @addOne

  addAll: (feeds) =>
    feeds.each(@addOne)

  addOne: (feed) =>
    if feed.id > 0
      view = new Beweek3.Views.Feeds.FeedView({model : feed})
      @$("ul").prepend(view.render().el)

  filterItems: () =>
    _filter = $(@el).find('.filter-box')
    _all = _filter.children("[data-type='all']").first()
    _child = _all.children('.checkbox-filter.custom_checkbox').first()
    if _child.hasClass('active') == true
      if filtered == true
        filtered = false
        @$("ul").empty()
        @addAll(@options.feeds)
    else
      conditions = []
      _.each _filter.children(), (el, ind, list)->
        key = $(el).data('type')
        if $(el).children('.checkbox-filter.custom_checkbox').first().hasClass('active') == true
          conditions.push(key)
      filter_cond = _.map conditions, (type) -> filter_map[type]
      if filter_cond.length > 0
        filtered_collection = new Beweek3.Collections.FeedsCollection(@options.feeds.filter (model)->
          for type_id in filter_cond
            if type_id == model.get('type_id')
              return true
          false
          )
        filtered = true

        @$("ul").empty()
        @addAll(filtered_collection)
        
  render: =>
    $(@el).html(@template(feeds: @options.feeds.toJSON())).attr 'data-code', 'events'
    @addAll(@options.feeds)

    return this