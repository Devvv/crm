Beweek3.Views.Profile ||= {}

class Beweek3.Views.Profile.PasswordView extends Backbone.View

  template: JST["backbone/templates/profile/password"]

  tagName: 'div'
  className: 'password-block'

  events :
    "click .submit" : "submit"
    "keyup .pass" : "check"

  check: () =>
    @$el.find('.submit').attr "disabled", "disabled"
    i = 0
    @$el.find('.pass').each ->
      if $(this).val().length > 5
        i++
    if i == 3
      @$el.find('.submit').removeAttr("disabled")

  submit : (e) =>
    e.preventDefault()
    e.stopPropagation()
    $.ajax
      beforeSend: =>
        @$el.find('.submit').val("Отправка...").attr "disabled", "disabled"
      url: "/ajax/user_pass"
      data: @$el.find("#user_pass_form").serialize()
      type: "post"
      success: (resp) =>
        if resp.success
          @$el.find("#user_pass_form")
            .after('<p>Пароль успешно изменен</p>')
            .remove()
        else
          @$el.find('#user_pass_errors').text(t["change_pass_error_#{resp.error}"])
          @$el.find('.submit').val("Отправить").removeAttr("disabled")

  render: ->
    $(@el).html(@template(@model.toJSON()))
    #this.$el.backboneLink(@model)
    return this