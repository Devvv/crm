class Beweek3.Models.Event extends Backbone.Model
  paramRoot: 'event'
  url: ->
    'events'

  defaults:
    id: 'new'

class Beweek3.Collections.EventsCollection extends Backbone.Collection
  model: Beweek3.Models.Event
  url: 'events'
