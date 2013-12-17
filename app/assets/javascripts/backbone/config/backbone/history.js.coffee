do (Backbone) ->

  oldLoadUrl = Backbone.History::loadUrl

  _.extend Backbone.History::,

    #  Override loadUrl & watch return value. Trigger event if no route was matched.
    #  @return {Boolean} True if a route was matched
    loadUrl: ->
      matched = oldLoadUrl.apply(@, arguments)
      @trigger('routeNotFound', arguments) if not matched
      matched

