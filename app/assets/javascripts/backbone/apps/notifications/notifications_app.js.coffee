@Learnster.module "NotificationsApp", (NotificationsApp, App, Backbone, Marionette, $, _) ->

  class NotificationsApp.Router extends App.Routers.AppRouter
    appRoutes:
      "notifications" : "listNotifications"

  API =
    listNotifications: ->
      new NotificationsApp.List.Controller()

  App.addInitializer ->
    new NotificationsApp.Router
      controller: API

  App.vent.on "notifications:block:clicked", (org) ->
    orgId = org.get('id')
    App.navigate "/organisation/#{orgId}/notifications"
