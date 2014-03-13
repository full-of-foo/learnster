do ($, window) ->

  window.TogetherJSConfig_siteName = "Learnster"

  window.TogetherJSConfig_toolName = "Collaboration"

  window.TogetherJSConfig_dontShowClicks = true

  window.TogetherJSConfig_suppressInvite = true

  window.TogetherJSConfig_disableWebRTC = true


  window.TogetherJSConfig_callToStart = (callback) ->
    callback = (-> {})
