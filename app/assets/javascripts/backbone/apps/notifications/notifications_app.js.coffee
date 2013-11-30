@Learnster.module "NotificationsApp", (NotificationsApp, App, Backbone, Marionette, $, _) ->

  class NotificationsApp.Router extends Marionette.AppRouter
    appRoutes:
      "notifications" : "listNotifications"

  API =
    listNotifications: ->
      new NotificationsApp.List.Controller()

  App.addInitializer ->
    new NotificationsApp.Router
      controller: API