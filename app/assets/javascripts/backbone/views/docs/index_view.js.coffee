Beweek3.Views.Docs ||= {}

class Beweek3.Views.Docs.IndexView extends Backbone.View
  template: JST["backbone/templates/docs/index"]

  tagName: 'div'
  className: 'main-container layer-block'

  events:
    "change .file_upload" : "add_new_file"
    "click .add_btn" : "add_file_click"

  initialize: () ->
    @options.docs.on('reset', @addAll)
    router.feeds.bind('add', @addOne)
    router.feeds.bind('remove', @removeOne)

  add_file_click: () =>
    @$el.find('.file_upload').trigger('click')

  add_new_file: (e) =>
    file = e.target.files[0]
    slicer = file_slicer(file)
    reader = new FileReader()

    noty = $.gritter.add(
      title: "Загрузка файла " + file.name
      text: "0%..."
    )

    attrs = {}
    attrs['type_id'] = 4
    mod = new Beweek3.Models.Feed({name: file.name})
    mod.save attrs,
             success: (feed) =>
               mod.id = feed.id
               reader.readAsBinaryString(slicer.get_next())
               nav('f-' + mod.id)

    window.cancelled = false
    reader.onloadend = (e) =>
      if !window.cancelled
        prc = Math.round( 100 / slicer.slices * (slicer.current_slice-1))
        text = prc + "%..."
        if prc < 100
          text += " "
        else
          text += " Загрузка завершена"



        $.gritter.change(noty, {
            title: "Загрузка файла " + file.name
            text: text
          }
        )
        WS.trigger "ext.upload", {feed_id: mod.id, name: file.name, size: file.size, size: slicer.slices, ind: slicer.current_slice, mess: encode64(e.target.result)}, (data) ->
          if slicer.current_slice <= slicer.slices
            reader.readAsBinaryString(slicer.get_next())


    #console.log(mod.save)




  addAll: (docs) =>
    docs.each(@addOne)

  addOne: (doc) =>
    if doc.attributes.type_id == 4
      view = new Beweek3.Views.Docs.DocView({model : doc})
      @$("ul").append(view.render().el)

  removeOne: (doc) =>
    if doc.attributes.type_id == 4
      @$('.event-line[url="/docs/f-'+doc.id+'"]').remove()

  render: =>
    $(@el).html(@template(docs: @options.docs.toJSON() )).attr 'data-code', 'docs'
    @addAll(@options.docs)

    return this
