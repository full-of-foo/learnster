@Learnster.module "MessagesApp", (MessagesApp, App, Backbone, Marionette, $, _, LearnsterCollab) ->

  API =
    routeChat: (id) ->
      App.execute "when:fetched", App.currentUser, =>
        if not LearnsterCollab.getInstance().isRunning()
          LearnsterCollab.getInstance().start()

      if arguments.length > 0 then App.goBack() else App.commands.execute("redirect:home")

  class MessagesApp.Router extends App.Routers.AppRouter
    appRoutes:
      "collaborate" : "routeChat"

    initialize: (options = {}) ->
      @route(/^collaborate&togetherjs=(.+)$/, "routeChat", _.bind(API.routeChat, API))

  App.addInitializer ->
    new MessagesApp.Router
      controller: API

, LearnsterCollab
