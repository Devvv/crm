class Beweek3.Models.Company extends Backbone.Model
  paramRoot: 'company'
  url: ->
    'companies'

  defaults:
    name: null

class Beweek3.Collections.CompaniesCollection extends Backbone.Collection
  model: Beweek3.Models.Company
  url: 'companies'
