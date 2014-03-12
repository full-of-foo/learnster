@LearnsterCollab = do ($, window) ->

  TogetherJS.on "ready", =>
    ui = window.TogetherJS.require('ui')
    ui.chat.urlChange = ( => console.log("Url changed"))
    $(ui.container).first().find('#togetherjs-menu-help').hide()
    $(ui.container).first().find('#togetherjs-menu-feedback').hide()
    $(ui.container).first().find('.togetherjs-window .togetherjs-follow').parent().hide()
    $(ui.container).first().find('.togetherjs-window .togetherjs-follow-question').parent().hide()

  getInstance: ->
    window.TogetherJS.refreshUserData()
    window.TogetherJS.reinitialize()

    publicMethods =
      isRunning: =>
        window.TogetherJS.running

      stop: =>
        window.TogetherJS() if window.TogetherJS.running

      start: =>
        @stop if @isRunning
        window.TogetherJS()

      togetherJs: =>
        window.TogetherJS

    return publicMethods
