Beweek3.Views.Feeds ||= {}

class Beweek3.Views.Feeds.NewView extends Backbone.View

  template: JST["backbone/templates/feeds/new"]

  tagName: 'div'
  className: 'main-container layers-container layer-block'

  events:
    "click #submit": "save"

  save: (e) =>
    e.preventDefault()
    e.stopPropagation()

    attrs = {}
    @$el.find('.edit_field').each ->
      attrs[$(this).attr('name')] = $(this).val()

    if @options.parent > 0
      attrs["feed_id"] = @options.parent
    if @options.user_to > 0
      attrs["user_to"] = @options.user_to
    switch @options.type
      when "post" then attrs['type_id'] = 0
      when "task" then attrs['type_id'] = 1
      when "deal" then attrs['type_id'] = 2
      when "event" then attrs['type_id'] = 3
      when "docs" then attrs['type_id'] = 4
      else attrs['type_id'] = 0

    model = new Beweek3.Models.Feed()
    model.save attrs,
      success: (feed) =>
        router.navigate(location.pathname.replace(RegExp('\/f\-new\.?[^\/]*'), "/f-#{feed.id}"), {trigger: true})

  render: ->
    $(@el).html(@template()).attr 'data-code', "f-new"
    #this.$el.backboneLink(@model)
    return this
