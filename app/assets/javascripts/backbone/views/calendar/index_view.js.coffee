Beweek3.Views.Calendar ||= {}

class Beweek3.Views.Calendar.IndexView extends Backbone.View

  template: JST["backbone/templates/calendar/index"]

  tagName: 'div'
  className: 'main-container layer-block'

  events: {}

  initialize: () ->
    @options.items.bind('reset', @addAll)
    router.feeds.bind('add', @addOne)
    router.feeds.bind('change', @updateOne)

  addAll: () =>
    @options.items.each(@addOne)

  addOne: (event) =>
    if parseInt(event.get('type_id')) == 3
      ev = {
        id: event.id
        title: event.get('name')
        allDay: false
        className: ""
        start: event.get('start')
        end: event.get('end')
      }
      @$el.find('.calendar').fullCalendar('renderEvent', ev, true)
      @$el.find('.filter_events_list .overview .inner').append('<a href="f-' + event.id + '" class="event_el"><div><span><div class="' + event.get('className') + '"></div>' + event.get('name') + '</span><span>' + event.get('text') + '</span></div><div><span>с ' + Beweek3.todate(event.get('start')) + '</span><span>по ' + Beweek3.todate(event.get('end')) + '</span></div></a>')
      @$el.find('.filter_events_list').tinyscrollbar()
      @$el.find('.filter_events_list').tinyscrollbar_update()

  updateOne: (event) =>
    if parseInt(event.get('type_id')) == 3
      @$el.find('.filter_events_list .overview .inner a[href="f-'+event.id+'"]')
        .html('<div><span><div class="' + event.get('className') + '"></div>' + event.get('name') + '</span><span>' + event.get('text') + '</span></div><div><span>с ' + Beweek3.todate(event.get('start')) + '</span><span>по ' + Beweek3.todate(event.get('end')) + '</span></div>')

  render: =>

    out = $(@el).html(@template()).attr 'data-code', 'calendar'

    $("#content").html(out)

    @$el.find('.calendar').fullCalendar({
      header:
        left:   ''
        center: ''
        right:  ''
      editable: true
      firstDay: 1
      defaultView: 'agendaDay'
      height: $('.calendar').parent().height()
      contentHeight: $('.calendar').parent().height()
      allDayText: 'На весь день'
      titleFormat:
        month: 'MMMM yyyy'
        week: "MMM d[ yyyy]{ '&#8212;'[ MMM] d yyyy}"
        day: 'dddd, MMM d, yyyy'
      columnFormat:
        month: 'ddd'
        week: 'ddd dd-MM'
        day: 'dddd'
      axisFormat: 'HH:mm'
      slotMinutes: 30
      defaultEventMinutes: 120
      viewDisplay: (view) ->
        el = $("#calendar_date_show")
        elP = el.parent()
        titleDate = (dd, dstr) ->
          el.val $.fullCalendar.formatDate(dd, dstr)
          elP.find('span').text $.fullCalendar.formatDate(dd, dstr)
          el.attr 'data-date', $.fullCalendar.formatDate(dd, dstr)
        el.datepicker({
          format: 'dd.MM.yyyy'
          weekStart: 1
          autoclose: false
          todayBtn: false
          todayHighlight: true
        })
        elP.unbind('click').bind 'click', ->
          el.datepicker('show').on 'changeDate', (ev) ->
            titleDate(ev.date, 'dd.MM.yyyy')
            el.datepicker('update')
            el.datepicker('hide')
            dateinput = new Date(ev.date)
            $('.calendar').fullCalendar('gotoDate', dateinput)
          $('.datepicker').css({
            top: elP.offset().top + 30,
            left: elP.offset().left
          })
        $('.viewChange').removeClass('active')
        $('#' + $('.calendar').fullCalendar('getView').name).addClass('active')
        switch view.name
          when "agendaDay"
            titleDate(view.start, "dd.MM.yyyy")
          when "agendaWeek"
            titleDate(view.start, "MMMM yyyy")
          when "month"
            titleDate(view.start, "MMMM yyyy")
      eventDrop: (event) =>
        #console.log event
        ev = @options.items.get event.id
        ev.set {start: event.start.toISOString(), end: event.end.toISOString()}
        ev.save()
        #@updateOne(ev)
        #reset()
      eventResize: (event) =>
        ev = @options.items.get event.id
        ev.set {start: event.start.toISOString(), end: event.end.toISOString()}
        ev.save()
      eventRender: (event) ->
        #console.log event
    })

    ###reset = =>
      $('.filter_events_list .overview .inner').empty()
      @options.items.each (n, i) ->
        $('.filter_events_list .overview .inner').append('<a href="f-' + n.id + '" class="event_el"><div><span><div class="' + n.get('className') + '"></div>' + n.get('name') + '</span><span>' + n.get('text') + '</span></div><div><span>с ' + Beweek3.todate(n.get('start')) + '</span><span>по ' + Beweek3.todate(n.get('end')) + '</span></div></a>')
        $('.filter_events_list').tinyscrollbar_update()
    $('.filter_events_list').mouseEventScroll()
    reset()###
    #$('.search input').box_search({
    #  find_block: $('.filter_events_list').find('a')
    #})
    $('#calendar_left').click ->
      $('.calendar').fullCalendar('prev')
      #reset()
    $('#calendar_right').click ->
      $('.calendar').fullCalendar('next')
      #reset()
    $('#calendar_today').click ->
      $('.calendar').fullCalendar('today')
      #reset()
    $('#agendaDay').click ->
      $('.calendar').fullCalendar( 'changeView', 'agendaDay' )
      #reset()
    $('#agendaWeek').click ->
      $('.calendar').fullCalendar( 'changeView', 'agendaWeek' )
      #reset()
    $('#month').click ->
      $('.calendar').fullCalendar( 'changeView', 'month' )
      #reset()

    @$el.find('.filter_events_list').mouseEventScroll()

    @addAll()

    #return this
