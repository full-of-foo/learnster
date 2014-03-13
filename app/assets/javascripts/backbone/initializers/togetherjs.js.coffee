@LearnsterCollab = do ($, window) ->

  # initializers
  window.TogetherJS._initializing = false

  window.TogetherJS.on 'before-init', =>
    window.TogetherJS._initializing = true

  window.TogetherJS.on "ready", =>
    $("#collab-loader").remove()
    $('#collaborate-dock-item').append('<div id="collab-success" class="basic-success"></div>')

    instance  = window.TogetherJS
    ui        = instance.require('ui')
    session   = instance.require("session")
    container = ui.container
    instance._initializing = false

    $(container).first().find('#togetherjs-menu-help').hide()
    $(container).first().find('#togetherjs-menu-feedback').hide()
    $(container).first().find('.togetherjs-window .togetherjs-follow').parent().hide()
    $(container).first().find('.togetherjs-window .togetherjs-follow-question').parent().hide()
    ui.chat.urlChange = -> console.log("Url changed")

    session.on "post-start", =>
      session.shareUrl  = ->
        hash = window.location.hash;
        m = /\?[^#]*/.exec(window.location.href)
        query = "";
        query = m[0] if m
        hash = hash.replace(/&?togetherjs-[a-zA-Z0-9]+/, "");
        hash = "/#/collaborate";
        return window.location.protocol + "//" + window.location.host + query +
               hash + "&togetherjs=" + session.shareId

    session.emit("post-start")

    instance.hub.on "togetherjs.hello togetherjs.hello-back", ->
      session.hub.removeListener('cursor-update', session.hub._listeners['cursor-update'][0])
      session.hub.removeListener('cursor-click', session.hub._listeners['cursor-click'][0])
      session.hub.removeListener('scroll-update', session.hub._listeners['scroll-update'][0])


    old_prepare = ui.prepareShareLink
    ui.prepareShareLink = (dummy_container) =>
      old_prepare(container)

    ui.prepareShareLink(null)

    window.TogetherJS.on "close", =>
      $('#collab-success').remove()

  # singleton
  getInstance: ->
    window.TogetherJS.refreshUserData()
    window.TogetherJS.reinitialize()

    publicMethods =
      isInitializing: =>
        window.TogetherJS._initializing

      isRunning: =>
        window.TogetherJS.running and TogetherJS.require

      stop: =>
        if window.TogetherJS.running and TogetherJS.require
          $("#collab-loader").remove()
          window.TogetherJS()

      start: =>
        if not(window.TogetherJS.running and TogetherJS.require)
          $('#collaborate-dock-item').prepend('<div id="collab-loader" class="basic-loader"></div>')
          window.TogetherJS()
          window.TogetherJS.emit('before-init')

      togetherJs: =>
        window.TogetherJS

      session: =>
        if window.TogetherJS.require
          window.TogetherJS.require('session')
        else
          false

    return publicMethods

