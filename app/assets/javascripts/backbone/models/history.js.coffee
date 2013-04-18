class Beweek3.Models.History extends Backbone.Model
  paramRoot: 'history'
  url: ->
    'histories'

  defaults:
    id: 'new'
    text: ''

class Beweek3.Collections.HistoriesCollection extends Backbone.Collection
  model: Beweek3.Models.History
  url: 'histories'