Beweek3.Views.Events ||= {}

class Beweek3.Views.Events.IndexView extends Backbone.View

  template: JST["backbone/templates/events/index"]

  tagName: 'div'
  className: 'overview'

  initialize: () ->
    @options.my_events.bind('reset', @addAll)
    @options.my_events.on('add', @addOne)
    @options.my_events.on('remove', @render)

  addAll: (events) =>
    events.each(@addOne)

  addOne: (event) =>
    view = new Beweek3.Views.Events.EventView({model : event})
    @$el.prepend(view.render().el)

    @render_tips()

  render_tips: =>
    #console.log 'render tips'
    zad_count =      router.my_events.where( {event_type: 1} ).length # задачи
    deals_count =    router.my_events.where( {event_type: 2} ).length # сделки
    calendar_count = router.my_events.where( {event_type: 3} ).length # события
    docs_count =     router.my_events.where( {event_type: 4} ).length # документы

    zad_el = $('#stason_tasks_counter')
    deals_el = $('#stason_deals_counter')
    calendar_el = $('#stason_calendar_counter')
    docs_el = $('#stason_docs_counter')

    zad_el.text(zad_count)
    deals_el.text(deals_count)
    calendar_el.text(calendar_count)
    docs_el.text(docs_count)

    if zad_count == 0
      zad_el.hide()
    else
      zad_el.show()

    if deals_count == 0
      deals_el.hide()
    else
      deals_el.show()

    if calendar_count == 0
      calendar_el.hide()
    else
      calendar_el.show()

    if docs_count == 0
      docs_el.hide()
    else
      docs_el.show()

  render: =>

    @render_tips()

    $(@el).html(@template())
    @addAll(@options.my_events)

    return this