$ ->

  $.fn.mouseEventScroll = (e) ->
    el = $(this)
    el.css "overflow-y", "auto"
    el.css "-webkit-overflow-scrolling", "touch"
    return
    ee = undefined

    el.css "position", "relative"  if el.css("position") isnt "absolute"
    ee = el.tinyscrollbar(
      axis: "y"
      wheel: 40
      scroll: true
      lockscroll: true
      size: "auto"
      sizethumb: "auto"
    )
    el.bind 'mousemove', ->
      $(this).find(".scrollbar").css "visibility", "visible"
    el.bind 'mouseleave', ->
      $(this).find(".scrollbar").css "visibility", "hidden"

  $(window).resize ->
    #$('.content_block').find('.viewport').css('overflow-y', 'auto')
    #$('.viewport').css('overflow-y', 'auto')

    #$('.content_block').find('.viewport').mouseEventScroll()
    #$('.filter_block').mouseEventScroll()

  $.fn.autoResizeTextarea = ->
    return this.each ->
      _t = $(this)
      _el = _t.parent().find('.text_area_div')
      _el.width( _t.width() )
      ee = (e) ->
        line_height = parseInt( _t.css('line-height') )
        min_line_count = 1
        min_line_height = min_line_count * line_height
        obj = e.target
        _el.text( obj.value )
        obj_height = _el.innerHeight()
        if (e.keyCode == 13)
          obj_height += line_height
        else if (obj_height < min_line_height)
          obj_height = min_line_height
        obj.style.height = obj_height + 'px'
      _t.bind 'keyup', (e) ->
        ee(e)
      _t.trigger 'keyup'


  $.fn.dPicker = (o) ->
    o = $.extend({
      el: 'none'
      TimeShow: false
      sdvLe: 0
      sdvTop: 0
    }, o)
    return this.each ->
      _t = $(this)
      o.t = _t
      _t.datepicker({
        format: 'dd.mm.yyyy',
        weekStart: 1,
        autoclose: false,
        todayBtn: false,
        todayHighlight: true,
        TimeShow: o.TimeShow,
        block: false
      }).on('show', (ev) ->
        o.block = false
        o.dateEl = $('.datepicker:visible')
        $('.datepicker:visible').css('left', parseInt( $('.datepicker:visible').css('left') ) + o.sdvLe)
        ######$('.datepicker:visible').css('top', parseInt( $('.datepicker:visible').css('top') ) + o.sdvTop)
        $('.datepicker:visible').css('top', parseInt( $('.main-container').css('top') ) + 9)
      ).on 'changeDate', (ev) ->
          date = $(this).data('date')
          time = $.trim(_t.find('span').text()).split(' ')[1]
          $(this).find('span').html( date + ' ' + time )
          $(this).find('input').val(date + ' ' + time)
          $(this).find('input').trigger('change')

  $.fn.filter_dropdown = (o) ->
    o = $.extend({
    left: 0,
    top: 0,
    elClick: $(this)
    action: (o) ->
    }, o)
    $(this).bind 'click', () ->
      o.t = $(this)

      $('.dropdown-menu').hide()
      _a = o.t.attr('data-toggle')
      _el = o.t.parents('.layers-container').find(_a)
      _el.css({
        top: o.t.parent().offset().top - $('.layers-container:last').offset().top - 5
        left: o.t.parent().offset().left - $('.layers-container:last').offset().left
      }).show()
      $('body').bind 'mousedown', (e) ->
        e = e || window.e
        el = e.target || e.srcElement
        if el.nodeName != 'A'
          $('body').unbind 'mousedown'
          $('.dropdown-menu').hide()
      ap = (o) ->
      ap(o.action(o))

  $.fn.backboneViewUpdate = (model) ->
    form = $(this)
    if model.attributes.can_edit == 1
      form.find('.edit_field').each ->
        el = $(this)
        name = el.attr 'name'
        if el.hasClass('chosen')
          if el.attr('name') == 'users' or el.attr('name') == 'contacts'
            n = if el.attr('name') == 'users' then "refers" else "conts"
            console.log n, model.attributes[n], el.get(0)
            el.val(model.attributes[n])
          else if el.attr('name') == 'user_to'
            el.val(model.attributes[name])
          el.trigger("liszt:updated")
        else if name == 'status_id'
          el.prev('span').text t["status_" + model.attributes[name]]
          el.prev('span').attr "data-sts", model.attributes[name]
          el.val model.attributes[name]
        else if name == 'importance'
          el.prev('span').text t["importance_" + model.attributes[name]]
          el.prev('span').attr "data-imp", model.attributes[name]
          el.val model.attributes[name]
        else if el.hasClass('datepicker')
          el.parents('a').attr 'data-date', Beweek3.todate model.attributes[name]
          el.prev('span').text Beweek3.todate model.attributes[name]
          el.val Beweek3.todate model.attributes[name]
        else
          el.val model.attributes[name]
    else
      form.find('.show_field').each ->
        el = $(this)
        name = el.attr 'data-name'
        val = model.attributes[name]
        if name == "importance"
          el.text t["importance_" + val]
        if name == "status_id"
          el.text t["status_" + val]
        if name == "start" or name == "end"
          el.text Beweek3.todate val
        if name == "user_to"
          el.html '<a href="u-'+val+'">' + router.users.get(val).get_name() + '</a>'
        if name == "feed_id"
          f = router.feeds.get(val)
          el.html '<a href="f-'+val+'">' + f.id  + " " + f.get('name') + '</a>'
        if name == "refers"
          us = []
          if val.length > 0
            for uid in val
              do (uid) ->
                u = router.users.get(uid)
                us.push '<a href="u-'+uid+'">' + u.get_name() + '</a>'
          el.html us.join(' , ') or t.not_selected
        if name == "conts"
          us = []
          if val.length > 0
            for uid in val
              do (uid) ->
                u = router.contacts.get(uid)
                us.push '<a href="c-'+uid+'">' + u.get_name() + '</a>'
          el.html us.join(' , ') or t.not_selected

  $.fn.backboneInnerUpdate = (model) ->
    form = $(this)
    form.find('.inner_edit_field').each ->
      el = $(this)
      name = el.attr 'name'
      el.val model.attributes[name]
        

  $.fn.box_search = (o) ->
    o = $.extend({
      find_block: '',
      pare: '.content_block'
    }, o)
    return this.each ->
      _t = $(this)
      _t.bind 'keyup change', ->

        if o.pare == 'inner'
          _p = _t.parents('.tab-pane').find('.no-bg')
        else
          _p = _t.parents('.content_block').find(o.find_block)
        val = _t.val()

        if val.length > 0

          find_el = _p.filter(':contains(' + val + ')')


          if find_el.length > 0
            _p.hide()
            find_el.show()

          else
            _p.hide()
        else
          _p.show()

  $.extend $.fn,

    updateDetail: () ->
      html = $(this)
      html.find('.content_block').find('.viewport').mouseEventScroll()
      html.find('.filter_block').mouseEventScroll()
      html.find('.auto_resize').autoResizeTextarea()
      html.find(".chosen").chosen()
      html.find('.data_change_time').each ->
        $(this).dPicker(
          sdvLe: -66
          sdvTop: 0
          TimeShow: true
        )
      html.find('[data-toggle]').filter_dropdown
        elClick: $(this),
        action: (o) ->
          if o.t.attr('data-toggle') == '#importance_layer'
            $('#importance_layer:visible li a').unbind('click')
            $('#importance_layer:visible li a').bind 'click', ->
              z = $(this).attr('data-imp')
              t =  $(this).text()
              html.find('.importance').find('span').text(t).attr('data-imp', z)
              html.find('.importance').find('input').val(z).trigger('change')
              $('.dropdown-menu').hide()
          if o.t.attr('data-toggle') == '#status_layer'
            $('#status_layer:visible li a').unbind('click')
            $('#status_layer:visible li a').bind 'click', ->
              z = $(this).attr('data-sts')
              t =  $(this).text()
              html.find('.status').find('span').text(t).attr('data-sts', z)
              html.find('.status').find('input').val(z).trigger('change')
              $('.dropdown-menu').hide()

    updateLayers: ->
      if $('.layers-container').size() == 1
        $('.layers-container').css {left: 10 + '%', zIndex: 100}
      else
        $('.layers-container').each (i, n) ->
          $(n).css {left: 5 + ((i + 1) * 5) + '%', zIndex: (i + 1) * 100}

    backboneLink: (model) ->
      #if parseInt(model.get('can_edit')) == 1
        $(this).find(".edit_field[type!=file][disabled!=disabled]").each ->
          el = $(this)
          name = el.attr("name")
          model.bind "change:" + name, =>
            switch name
              when "user_to", "feed_id", "refers", "conts"
                el.val(model.get(name))
                el.trigger("liszt:updated")
              when "status_id"
                el.prev('span').text t["status_" + model.get(name)]
                el.prev('span').attr "data-sts", model.get(name)
                el.val model.get(name)
              when "importance"
                el.prev('span').text t["importance_" + model.get(name)]
                el.prev('span').attr "data-imp", model.get(name)
                el.val model.get(name)
              when "start", "end"
                el.parents('a').attr 'data-date', model.get(name)
                el.prev('span').text Beweek3.todate model.get(name)
                el.val Beweek3.todate model.get(name)
              else
                el.val model.get(name)

          el.bind "change", ->
            attrs = undefined
            el = $(this)
            attrs = {}
            attrs[el.attr("name")] = el.val()
            model.set attrs
            model.save()

      #else
        $(this).find(".show_field").each ->
          el = $(this)
          name = el.attr 'data-name'
          model.bind "change:" + name, =>
            console.log "show change"
            switch name
              when "importance", "status_id"
                el.text t[name.replace('_id', '') + "_" + model.get(name)]
              when "start", "end"
                el.text Beweek3.todate model.get(name)
              when "user_to"
                u = router.users.get(model.get(name))
                if u
                  el.html '<a href="u-' + model.get(name) + '">' + router.users.get(model.get(name)).get_name() + '</a>'
              when "feed_id"
                f = router.feeds.get(model.get(name))
                if f
                  el.html '<a href="f-' + model.get(name) + '">' + f.id  + " " + f.get('name') + '</a>'
              when "refers"
                us = []
                if model.get(name).length > 0
                  for uid in model.get(name)
                    do (uid) ->
                      u = router.users.get(uid)
                      us.push '<a href="u-' + uid + '">' + u.get_name() + '</a>'
                el.html us.join(' , ') or t.not_selected
              when "conts"
                us = []
                if model.get(name).length > 0
                  for uid in model.get(name)
                    do (uid) ->
                      u = router.contacts.get(uid)
                      us.push '<a href="u-' + uid + '">' + u.get_name() + '</a>'
                el.html us.join(' , ') or t.not_selected
              else
                el.text model.get(name)