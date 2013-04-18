#= require base64
#= require md5
#= require jquery
#= require jquery_ujs
#= require jqueryui
#= require scroll
#= require datepicker
#= require fullcalendar
#= require chosen
#= require plugins
#= require ajax_form
#= require underscore
#= require hamlcoffee
#= require websocket_rails/main
#= require backbone
#= require backbone_rails_sync
#= require backbone/beweek3
#= require notify
#= require chat

$ ->
  $.extend $.gritter.options, {
    position: 'bottom-right'
    fade_in_speed: 'fast'
    fade_out_speed: 300
    time: 4000
  }


