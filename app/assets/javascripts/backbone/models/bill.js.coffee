class Beweek3.Models.Bill extends Backbone.Model
  paramRoot: 'bill'
  url: ->
    'bills'

  defaults:
    id: 'new'
    name: ''
    bill_date: Beweek3.get_start()    
    importance: 1
    status_id: 0            
    user_id: 0
    feed_id: 0
    sum: 0
    total_sum: 0
    discount: 0
    num: ''        
    refers: []
    can_edit: 1

  set_total: ->
    sum = parseFloat(@attributes.sum)
    discount = parseInt(@attributes.discount)
    if sum > 0
      if discount > 0
        @attributes.total_sum = sum - sum * discount / 100        
      else
        @attributes.total_sum = @attributes.sum            

  validate: (attrs) ->
    #if !attrs.name
      #"name must be at least 1 characters"

class Beweek3.Collections.BillsCollection extends Backbone.Collection
  model: Beweek3.Models.Bill
  url: 'bills'