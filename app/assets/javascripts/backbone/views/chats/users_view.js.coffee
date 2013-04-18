Beweek3.Views.Chats ||= {}

class Beweek3.Views.Chats.UsersView extends Backbone.View
  template: JST["backbone/templates/chats/users"]

  initialize: ->
    #user = router.users.get(@model.attributes.user_id)
    #@model.attributes.user_name = user.get_name()
    #if @model.attributes.user_to > 0
    #  user_to = router.users.get(@model.attributes.user_to)
    #  if user_to
    #    @model.attributes.user_to_name = user_to.get_name()

  tagName: "div"

  className: "right_column"

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  addAll: () =>

    @options.users.each(@addOne)

  addOne: (user) =>
    view = new Beweek3.Views.Chats.UserView({model : user})
    @$el.find('.all_contacts').append(view.render().el)

  render: ->
    $(@el).html(@template())
    @addAll()
    return this
