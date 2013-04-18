Beweek3.Views.Feeds ||= {}

class Beweek3.Views.Feeds.ShowView extends Backbone.View

  template: JST["backbone/templates/feeds/show"]

  tagName: 'div'
  className: 'main-container layers-container layer-block'

  events :
    "click .trash" : "destroy_item"
    "change .file_upload" : "upload"
    "click .history-add" : "addHistory"
    "change .history-filter" : "filterHistory"
    "click #add_task_btn" : "addSubfeed"

  initialize: =>
    router.histories.bind('add', @renderHistory)
    #@model.on "change:can_edit", =>
    #  @render()
    #  @$el.updateDetail().updateLayers()


    @model.on "change:files", @change_files

    #@model.on "remove", =>
      #router.navigate(location.pathname.replace(RegExp('\/f\-' + @model.id + '\.?[^\/]*'), ""), {trigger: false})
      #@$el.remove()
    #CH.bind "upload_file", (data) =>
    #  return # перенесено в app_router
    #  if data.feed_id == @model.id
    #    @model.attributes.files ||= {}
    #    @model.attributes.files[data.id] = data
    #    dl = ''
    #    if parseInt(@model.get('can_edit'))
    #      dl = '<a class="del_file" data-id="' + data.id + '" href="javascript:;">X</a>'
    #    @$('.files_list').append('<div class="files" data-id="' + data.id + '" data-type="' + data.file_content_type + '"><p><a class="link" href="/download/' + data.id + '">' + data.file_file_name + '</a> ' + dl + '</p></div>')
    CH.bind "delete_feed_file", (data) =>
      if @model.attributes.files[data.id]
        delete @model.attributes.files[data.id]
        @$('.files[data-id="'+data.id+'"]').remove()

  change_files: ()=>
    files_array = @model.get('files')

    @$('.files_list').html('')

    for fid, data of files_array

      dl = ''
      if parseInt(@model.get('can_edit'))
        dl = '<a class="del_file" data-id="' + data.id + '" href="javascript:;">X</a>'
      @$('.files_list').append('<div class="files" data-id="' + data.id + '" data-type="' + data.file_content_type + '"><p><a class="link" href="/download/' + data.id + '">' + data.file_file_name + '</a> ' + dl + '</p></div>')

  addSubfeed: (e) =>
    th = $(e.currentTarget)
    type = th.attr('data-type-id')
    sel = $('#add_' + type + '_select')
    pr = sel.val()
    if pr > 0
      f = router.feeds.get(pr)
      if f
        f.save({feed_id: @model.id})
        sel.find('option[value="'+pr+'"]').remove()
        sel.val(0)
        sel.trigger('liszt:updated')
        false

  addHistory: (e) =>
    text = @$el.find('.history-text').val()
    if text.length > 1
      router.histories.create({type_id: 0, text: text, user_id: uid, feed_id: @model.id, company_id: cid})
      @$el.find('.history-text').val('')
      @model.set('comments', @model.get('comments') + 1 )

  renderHistory: (history) =>
    if @model.id == history.get('feed_id') and history.id > 0

      view = new Beweek3.Views.Histories.FeedView(model: history)
      @$el.find('#histories').prepend(view.render().$el)

  filterHistory: ->
    if @$el.find('.history-filter').is(':checked')
      @$el.find('#histories .history-block[data-type!=0]').hide()
    else
      @$el.find('#histories .history-block[data-type!=0]').show()
    @$el.find('.content_block').find('.viewport').mouseEventScroll()

  upload: (e) =>
    file = e.target.files[0]
    slicer = file_slicer(file)
    reader = new FileReader()
    reader.readAsBinaryString(slicer.get_next())
    noty = $.gritter.add(
      title: "Загрузка файла " + file.name
      text: "0%..."
    )
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
        WS.trigger "ext.upload", {feed_id: @model.id, name: file.name, size: file.size, size: slicer.slices, ind: slicer.current_slice, mess: encode64(e.target.result)}, (data) ->
          if slicer.current_slice <= slicer.slices
            reader.readAsBinaryString(slicer.get_next())

  destroy_item: =>
    if confirm "Удалить запись?"
      #console.log 'ShowView destroy'
      id = @model.id
      @model.destroy()
      #@remove()
      nav( Beweek3.unlink('f-' + id)  )
      #return false
      #@model.destroy() if @model



  render: ->

    ts = router.feeds.where({feed_id: @model.id, type_id: 1})
    ds = router.feeds.where({feed_id: @model.id, type_id: 2})
    es = router.feeds.where({feed_id: @model.id, type_id: 3})
    dcs = router.feeds.where({feed_id: @model.id, type_id: 4})

    $(@el).html(@template(@model.toJSON())).attr 'data-code', "f-#{@model.id}"
    @$el.backboneLink(@model)

    @$el.find('.ts_count').text(ts.length || "")
    @$el.find('.ds_count').text(ds.length || "")
    @$el.find('.es_count').text(es.length || "")
    @$el.find('.dcs_count').text(dcs.length || "")

    task_view = new Beweek3.Views.Feeds.SubfeedsView(feeds: new Beweek3.Collections.FeedsCollection().reset(ts), type: 1, id: @model.id)
    @$el.find('.tab-pane#task').append(task_view.render().el)

    deal_view = new Beweek3.Views.Feeds.SubfeedsView(feeds: new Beweek3.Collections.FeedsCollection().reset(ds), type: 2, id: @model.id)
    @$el.find('.tab-pane#deal').append(deal_view.render().el)

    event_view = new Beweek3.Views.Feeds.SubfeedsView(feeds: new Beweek3.Collections.FeedsCollection().reset(es), type: 3, id: @model.id)
    @$el.find('.tab-pane#event').append(event_view.render().el)

    docs_view = new Beweek3.Views.Feeds.SubfeedsView(feeds: new Beweek3.Collections.FeedsCollection().reset(dcs), type: 4, id: @model.id)
    @$el.find('.tab-pane#docs').append(docs_view.render().el)

    return this
