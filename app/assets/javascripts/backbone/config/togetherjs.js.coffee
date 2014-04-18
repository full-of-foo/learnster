do ($, window) ->

  window.TogetherJSConfig_siteName = "Learnster"

  window.TogetherJSConfig_toolName = "Collaboration"

  window.TogetherJSConfig_dontShowClicks = true

  window.TogetherJSConfig_suppressInvite = false

  window.TogetherJSConfig_disableWebRTC = true

  window.TogetherJSConfig_ignoreMessages = ["cursor-update", "keydown", "scroll-update"]

  window.TogetherJSConfig_ignoreForms = [":password"]


  window.TogetherJSConfig_callToStart = (callback) ->
    callback = (-> {})
