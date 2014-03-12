@Learnster.module "MessagesApp", (MessagesApp, App, Backbone, Marionette, $, _, TogetherJS) ->

  class MessagesApp.Router extends App.Routers.AppRouter
    initialize: (options) ->
      @route(/^(.+?)&togetherjs=(.+?)$/, "routeChat", options.controller.routeChat);

  API =
    routeChat: (route, chatId) ->
      console.log "chat route", route, chatId

  App.addInitializer ->
    new MessagesApp.Router
      controller: API

, TogetherJS
