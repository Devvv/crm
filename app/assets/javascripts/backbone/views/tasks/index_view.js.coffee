Beweek3.Views.Tasks ||= {}

class Beweek3.Views.Tasks.IndexView extends Backbone.View
  template: JST["backbone/templates/tasks/index"]

  tagName: 'div'
  className: 'main-container layer-block'

  events :
    "click .filter-line" : "filterItems"

  initialize: () ->
    @options.tasks.bind('reset', @addAll)
    router.feeds.bind('add', @addOne)

  filterItems: (e) =>
    #@render() - нельзя, т.к. чекбоксы заново отрисовываются шаблоном
    filter = $(@el).find('.filter-box')

    author = filter.find('div[data-type=author] div.checkbox-filter').hasClass('active')
    exec =   filter.find('div[data-type=exec] div.checkbox-filter').hasClass('active')
    watch =  filter.find('div[data-type=watch] div.checkbox-filter').hasClass('active')

    click_to = ''
    if $(e.target).hasClass('filter-line')
      click_to = $(e.target).attr('data-type')
    else
      click_to = $(e.target).parent('.filter-line').attr('data-type')

    if click_to == 'all'
      if filter.find('div[data-type=all] div.checkbox-filter').hasClass('active')
        # установка чекбокса
        filter.find('div[data-type=author] div.checkbox-filter').removeClass('active')
        filter.find('div[data-type=exec] div.checkbox-filter').removeClass('active')
        filter.find('div[data-type=watch] div.checkbox-filter').removeClass('active')
      else
        # снятие чекбокса
        filter.find('div[data-type=author] div.checkbox-filter').addClass('active')
        filter.find('div[data-type=exec] div.checkbox-filter').addClass('active')
        filter.find('div[data-type=watch] div.checkbox-filter').addClass('active')

    else
      if author or exec or watch
        filter.find('div[data-type=all] div.checkbox-filter').removeClass('active')
      else
        filter.find('div[data-type=all] div.checkbox-filter').addClass('active')

    @$("ul").empty()
    @addAll()

  addAll: () =>
    @options.tasks.each(@addOne)

  addOne: (task) =>
    if task.get("type_id") == 1

      filter = $(@el).find('.filter-box')

      all = filter.find('div[data-type=all] div.checkbox-filter').hasClass('active')

      hurry = filter.find('div[data-type=hurry] div.checkbox-filter').hasClass('active')

      wait = filter.find('div[data-type=wait] div.checkbox-filter').hasClass('active')
      work = filter.find('div[data-type=work] div.checkbox-filter').hasClass('active')
      comp = filter.find('div[data-type=comp] div.checkbox-filter').hasClass('active')

      if all
        author = true
        exec =   true
        watch =  true
      else

        author = filter.find('div[data-type=author] div.checkbox-filter').hasClass('active')
        exec =   filter.find('div[data-type=exec] div.checkbox-filter').hasClass('active')
        watch =  filter.find('div[data-type=watch] div.checkbox-filter').hasClass('active')

      today =  filter.find('div[data-type=today] div.checkbox-filter').hasClass('active')

      if !hurry or (task.get('importance') == 2)
        if (wait and task.get('status_id') == 0) or (work and task.get('status_id') == 50) or (comp and task.get('status_id') == 100)

          im_watch = false
          if ( watch )
            refers = task.get('refers')
            for ref in refers
              if ref == uid
                im_watch = true
                break

          if ( author and task.get('user_id') == uid ) or ( exec and task.get('user_to') == uid ) or ( watch and im_watch )
            d = new Date
            m = d.getMonth() + 1
            day = d.getDate()
            current_date = d.getFullYear() + '-' + ( if m <= 9 then '0' + m else m ) + '-' + ( if day <= 9 then '0' + day else day )

            if !today or ( task.get('created_at').indexOf(current_date) == 0  )

              view = new Beweek3.Views.Tasks.TaskView({model : task})
              @$("ul").append(view.render().el)

  render: =>
    $(@el).html(@template(tasks: @options.tasks.toJSON() )).attr 'data-code', 'tasks'
    @addAll()

    return this
