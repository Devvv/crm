Beweek3.Views.Feeds ||= {}

class Beweek3.Views.Feeds.FeedView extends Backbone.View
  template: JST["backbone/templates/feeds/feed"]

  initialize: ->
    user = router.users.get(@model.get("user_id"))
    @model.on "change", (feed) =>
      @render()
    @model.attributes.user_name = user.get_name()
    if @model.get('user_to') > 0
      user_to = router.users.get(@model.get('user_to'))
      if user_to
        @model.set('user_to_name', user_to.get_name())
    @model.on "destroy", @destroy

  events:
    "click .destroy" : "destroy"

  tagName: "li"

  className: "event-line layer"

  destroy: () =>
    #@model.destroy()
    #console.log 'FeedView destroy'
    #@model.destroy()
    @remove()

    #return false

  render: ->
    $(@el).html(@template(@model.toJSON())).addClass(FC[@model.get("type_id")]).attr 'url', "/events/f-#{@model.id}"
    return this
