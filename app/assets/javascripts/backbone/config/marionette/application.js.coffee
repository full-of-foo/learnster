do (Backbone, $, _, window) ->

  _.extend Backbone.Marionette.Application::,

    navigate: (route, options = {}) ->
      # add pound is invalid route
      route = "#" + route if route.charAt(0) is "/"
      # always trigger route
      options["trigger"] = true
      Backbone.history.navigate route, options

    getCurrentRoute: ->
      frag = Backbone.history.fragment
      if _.isEmpty(frag) then null else frag

    goBack: ->
      Backbone.history.history.back()

    refreshCurrentRoute: ->
      @navigate(@getCurrentRoute())

    startHistory: ->
      if Backbone.history
        Backbone.history.start()

    register: (instance, id) ->
      @_registry ?= {}
      @_registry[id] = instance

    unregister: (instance, id) ->
      delete @_registry[id]

    resetRegistry: ->
      oldCount = @getRegistrySize()
      for k, controller of @_registry
        controller.region.close()
      msg = "There were #{oldCount} controllers in the _registry, there are now #{@getRegistrySize()}"
      if @getRegistrySize() > 0 then console.warn(msg, @_registry) else console.log(msg)

    getRegistrySize: ->
      _.size @_registry

    makeToast: (options = {}) ->
      _closeToast = ->
        console.log "closing"
        _.delay((=> @myNotify.close()), 2200)
      _showToast = ->
        @show()

      toast = new Notify 'Learnster',
        body: options.text
        permissionGranted: _showToast
        icon: "images/learnster-toast.png"
        notifyShow: _closeToast

      if toast.needsPermission()
        toast.requestPermission()
      toast.show()
