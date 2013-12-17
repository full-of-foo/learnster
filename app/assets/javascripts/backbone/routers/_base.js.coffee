@Learnster.module "Routers", (Routers, App, Backbone, Marionette, $, _) ->

  class Routers.AppRouter extends Marionette.AppRouter

    before: (route, params) ->
      # console.log "Before #{route}: #{params}" if App.environment is "development"

    after: (route, params) ->
      # console.log "After #{route}: #{params}" if App.environment is "development"
