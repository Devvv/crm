class Beweek3.Models.Message extends Backbone.Model
  paramRoot: 'message'
  url: ->
    'messages'

  defaults:
    id: 'new'
    text: ''

class Beweek3.Collections.MessagesCollection extends Backbone.Collection
  model: Beweek3.Models.Message
  url: 'messages'
