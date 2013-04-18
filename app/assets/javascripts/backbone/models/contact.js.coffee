class Beweek3.Models.Contact extends Backbone.Model
  paramRoot: 'contacts'
  url: ->
    'contacts'

  defaults:
    name: null

  get_name: ->
    if @get('name')
      if @get('surname')
        @get('surname') + " " + @get('name')
      else
        @get('name')
    else
      @get('email')

class Beweek3.Collections.ContactsCollection extends Backbone.Collection
  model: Beweek3.Models.Contact
  url: 'contacts'
