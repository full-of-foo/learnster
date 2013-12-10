do (Backbone, $, _) ->

  _.extend Backbone.Marionette.Application::,

    navigate: (route, options = {}) ->
      # cannot nav to login when logged in
      route = @rootRoute  if ( ( route.indexOf("login") isnt -1 and
       @rootRoute isnt "/login" ) or route is null)
      # add pound is invalid route
      route = "#" + route if route.charAt(0) is "/"
      # always trigger route
      options["trigger"] = true
      Backbone.history.navigate route, options

    getCurrentRoute: ->
      frag = Backbone.history.fragment
      if _.isEmpty(frag) then null else frag

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
      toast = new Notify 'Learnser',
        body:                 options.text
        permissionGranted: -> toast.show()
        notifyShow: ->        _.delay( ( -> toast.myNotify.close() ), 2500)
        icon:                 "images/learnster-toast.png"

      if toast.needsPermission()
        toast.requestPermission()
      toast.show()
