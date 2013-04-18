#= require jquery
$ ->
  $('.abs_pass').each ->
    el = $(this).parent().find('input:last')
    th = $(this)
    $(this).parent().bind 'click', ->
      th.hide()
    $(this).bind 'click', ->
      $(this).hide()
      el.focus()
    el.bind 'blur', ->
      if el.val().length > 0
        th.hide()
      else
        th.show()
    el.bind 'focus', ->
      th.hide()