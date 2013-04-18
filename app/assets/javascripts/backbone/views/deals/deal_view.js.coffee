Beweek3.Views.Deals ||= {}

class Beweek3.Views.Deals.DealView extends Backbone.View
  template: JST["backbone/templates/deals/deal"]

  initialize: ->
    user = router.users.get(@model.attributes.user_id)
    if user
      @model.attributes.user_name = user.get_name()
    if @model.attributes.user_to > 0
      user_to = router.users.get(@model.attributes.user_to)
      if user_to
        @model.attributes.user_to_name = user_to.get_name()
    CH.bind "update_feed", (feed) =>
      if @model.id == feed.id
        @model.set feed
        if @$el.get(0)
          @render()

  events:
    "click .destroy" : "destroy"

  tagName: "li"

  className: "event-line layer"

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    $(@el).html(@template(@model.toJSON())).attr 'url', '/deals/f-' + @model.id
    return this
