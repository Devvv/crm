class Beweek3.Models.Position extends Backbone.Model
  paramRoot: 'position'
  url: ->
    'positions'

  defaults:
    id: 'new'
    bill_id: 0
    count: 0
    units: ''
    price: 0
    sum: 0
    refers: []
    can_edit: 1

  validate: (attrs) ->
    #if !attrs.name
      #"name must be at least 1 characters"

class Beweek3.Collections.PositionsCollection extends Backbone.Collection
  model: Beweek3.Models.Position
  url: 'positions'