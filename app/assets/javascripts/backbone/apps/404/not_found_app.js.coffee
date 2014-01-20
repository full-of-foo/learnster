@Learnster.module "NotFoundApp", (NotFoundApp, App, Backbone, Marionette, $, _) ->

  class NotFoundApp.Router extends App.Routers.AppRouter
    appRoutes:
      '404'  : 'showNotFound'

    onRouteNotFound: ->
      if App.getCurrentRoute() isnt "/404" and App.getCurrentRoute()
        App.navigate "/404",
           replace: true

  API =
    showNotFound: ->
      new NotFoundApp.Show.Controller()


  App.commands.setHandler "show:not:found", ->
    if App.getCurrentRoute() isnt "/404" and App.getCurrentRoute()
        App.navigate "/404",
           replace: true

  App.addInitializer ->
    new NotFoundApp.Router
      controller: API
