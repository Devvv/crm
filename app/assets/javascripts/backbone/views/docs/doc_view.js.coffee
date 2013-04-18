Beweek3.Views.Docs ||= {}

class Beweek3.Views.Docs.DocView extends Backbone.View
  template: JST["backbone/templates/docs/doc"]

  initialize: ->
    user = router.users.get(@model.attributes.user_id)
    if user
      @model.attributes.user_name = user.get_name()
    if @model.attributes.user_to > 0
      user_to = router.users.get(@model.attributes.user_to)
      if user_to
        @model.attributes.user_to_name = user_to.get_name()

  events:
    "click .destroy" : "destroy"

  tagName: "li"

  className: "event-line layer"

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    $(@el).html(@template(@model.toJSON())).attr 'url', '/docs/f-' + @model.id
    return this
