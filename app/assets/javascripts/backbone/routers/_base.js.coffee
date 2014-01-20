@Learnster.module "Routers", (Routers, App, Backbone, Marionette, $, _) ->

  class Routers.AppRouter extends Marionette.AppRouter

    before: (route, params) ->
      console.log "Before #{route}: #{params}" if App.environment is "development"
      user = App.reqres.request "get:current:user"

      if(not App.isPermittedRoute(user, route) and user)
        console.log("#{App.getCurrentRoute()}: not permitted") if App.environment is "development"
        App.commands.execute("show:not:found")                 if App.getCurrentRoute() isnt "404"
        return false


    after: (route, params) ->
      console.log "After #{route}: #{params}" if App.environment is "development"
