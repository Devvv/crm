Beweek3.Views.Histories ||= {}

class Beweek3.Views.Histories.FeedView extends Backbone.View
  template: JST["backbone/templates/histories/feed"]

  initialize: ->
    user = router.users.get(@model.get('user_id'))
    @model.attributes.user_name = user.get_name()
    @model.attributes.user_photo = user.get('photo_path_thumb')

  tagName: "div"

  className: "history-block"

  render: ->
    $(@el).html(@template(@model.toJSON())).attr 'data-type', @model.get('type_id')
    return this