# encoding: utf-8
Beweek3.Views.Profile ||= {}

class Beweek3.Views.Profile.ProfileView extends Backbone.View

  template: JST["backbone/templates/profile/profile"]

  tagName: 'div'
  className: 'main-container layer-block'

  events :
    "change .edit_field" : "update"
    "change .photo_field" : "upload_photo"
    "click .change_password" : "change_password"

  initialize: ->
    @social_links()
    CH.bind "update_user_photo", (params) =>
      if @model.id*1 == params.id*1
        @model.set "photo_path_medium", params.photo_path_medium
        @model.set "photo_path_thumb", params.photo_path_thumb
        @$el.find('.person-img img').attr('src', params.photo_path_medium)

  upload_photo: (e) =>
    #@$el.find('#user_photo').ajaxSubmit()
    #console.log e.target
    file = e.target.files[0]
    slicer = file_slicer(file)
    reader = new FileReader()

    reader.readAsBinaryString(slicer.get_next())

    noty = $.gritter.add(
      title: "Загрузка файла " + file.name
      text: "0%..."
    )

    reader.onloadend = (e) =>
      #console.log e.target.result

      noty = $.gritter.change(
        noty
        {
          title: "Загрузка файла " + file.name
          text: Math.round( 100 / slicer.slices * (slicer.current_slice-1)) + "%..."
        }
      )

      console.log noty

      WS.trigger(
        "ext.upload"
        {user_id: @model.id, name: file.name, size: file.size, size: slicer.slices, ind: slicer.current_slice, mess: encode64(e.target.result)}
        (data) ->
          if slicer.current_slice <= slicer.slices
            reader.readAsBinaryString(slicer.get_next())
        (data) ->
          if data.stat == "error"
            noty = $.gritter.add(
              title: "Ошибка загрузки файла " + file.name
              text: data.data
            )
      )

    #slicer = file_slicer(file)

    #console.log file

    #console.log file.slice(1, 100)

    #console.log reader.readAsBinaryString(slicer.get_next()) while slicer.current_slice < slicer.slices

    #WS.trigger("ext.upload", {data: reader.readAsBinaryString(slicer.get_next())}) while slicer.current_slice < slicer.slices

  change_password: () =>
    view = new Beweek3.Views.Profile.PasswordView(model: @model)
    @$el.find('.change_password')
      .after(view.render().el)
      .remove()

  social_links: () =>
    $.ajax
      type: "post"
      url: "/ajax/social_links"
      success: (data) =>
        @$el.find('#social_links').html(data)

  update : (e) ->
    e.preventDefault()
    e.stopPropagation()
    @model.save()

  render: ->
    $(@el).html(@template(@model.toJSON())).attr 'data-code', 'profile'
    this.$el.backboneLink(@model)
    return this