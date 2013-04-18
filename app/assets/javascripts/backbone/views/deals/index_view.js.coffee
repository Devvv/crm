Beweek3.Views.Deals ||= {}

class Beweek3.Views.Deals.IndexView extends Backbone.View
  template: JST["backbone/templates/deals/index"]

  tagName: 'div'
  className: 'main-container layer-block'

  initialize: () ->
    @options.deals.bind('reset', @addAll)
    router.feeds.bind('add', @addOne)
    router.feeds.bind('remove', @removeOne)

  events :
    "click .filter-line" : "filterItems"

  filterItems: () =>
    #@render() - нельзя, т.к. чекбоксы заново отрисовываются шаблоном
    @$("ul").empty()
    @addAll()

  addAll: () =>
    @options.deals.each(@addOne)

  addOne: (deal) =>
    if deal.get('type_id') == 2

      filter = $(@el).find('.filter-box')

      todo =  filter.find('div[data-type=todo] div.checkbox-filter').hasClass('active')
      doing = filter.find('div[data-type=doing] div.checkbox-filter').hasClass('active')
      done =  filter.find('div[data-type=done] div.checkbox-filter').hasClass('active')
      if (todo and deal.get('status_id') == 0) or (doing and deal.get('status_id') == 50) or (done and deal.get('status_id') == 100)
        view = new Beweek3.Views.Deals.DealView({model : deal})
        @$("ul").append(view.render().el)

  removeOne: (deal) =>
    if deal.attributes.type_id == 2
      @$('.event-line[url="/deals/f-'+deal.id+'"]').remove()

  render: =>
    $(@el).html(@template(deals: @options.deals.toJSON() )).attr 'data-code', 'deals'
    @addAll()

    return this
