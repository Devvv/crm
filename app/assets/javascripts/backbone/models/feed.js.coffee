class Beweek3.Models.Feed extends Backbone.Model
  paramRoot: 'feed'
  url: ->
    'feeds'

  defaults:
    id: 'new'
    name: ''
    text: ''
    start: Beweek3.get_start()
    end: Beweek3.get_end()
    importance: 1
    status_id: 0
    user_to: 0
    public: 0
    refers: []
    users: []
    contacts: []
    conys: []
    files: []
    can_edit: 1


  status: =>
    status_id = @get('status_id')
    switch status_id
      when 0
        'в ожидании'
      when 50
        'выполняется'
      when 100
        'завершена'
      else
        ''

  validate: (attrs) ->
    if !attrs.name
      "name must be at least 1 characters"


class Beweek3.Collections.FeedsCollection extends Backbone.Collection
  model: Beweek3.Models.Feed
  url: 'feeds'
