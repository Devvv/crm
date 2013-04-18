Beweek3.Views.Tasks ||= {}

class Beweek3.Views.Tasks.TaskView extends Backbone.View
  template: JST["backbone/templates/tasks/task"]

  initialize: ->
    user = router.users.get(@model.attributes.user_id)
    if user
      @model.attributes.user_name = user.get_name()
    if @model.attributes.user_to > 0
      user_to = router.users.get(@model.attributes.user_to)
      if user_to
        @model.attributes.user_to_name = user_to.get_name()
    @model.on "change", (task) =>
      @render()
    @model.on "remove", (task) =>
      @destroy()

  events:
    "click .destroy" : "destroy"

  tagName: "li"

  className: "event-line layer"

  destroy: () ->
    @model.destroy() if @model
    @remove()

    return false

  render: ->
    $(@el).html(@template(@model.toJSON())).attr 'url', '/tasks/f-' + @model.id
    return this
