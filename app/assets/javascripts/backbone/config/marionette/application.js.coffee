do (Backbone) ->

    _.extend Backbone.Marionette.Application::,

        navigate: (route, options = {}) ->
            route = "#" + route if route.charAt(0) is "/"
            Backbone.history.navigate route, options

        getCurrentRoute: ->
            Backbone.history.fragment


