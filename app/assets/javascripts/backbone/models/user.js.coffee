class Beweek3.Models.User extends Backbone.Model
  paramRoot: 'user'
  url: ->
    'users'

  defaults:
    name: null

  get_name: =>
    if @get('name')
      if @get('surname')
        @get('surname') + " " + @get('name')
      else
        @get('name')
    else
      @get('email')

class Beweek3.Collections.UsersCollection extends Backbone.Collection
  model: Beweek3.Models.User
  url: 'users'
