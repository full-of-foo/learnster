@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Notification extends Entities.Models
    urlRoot: Routes.api_activities_path()

  class Entities.NotificationsCollection extends Entities.Collections
    url: Routes.api_activities_path()
    model: Entities.Notification

  API =
    getNotificationEntities: ->
      notifications = new Entities.NotificationsCollection
      notifications.fetch
        reset: true
      notifications

  App.reqres.setHandler "org:notification:entities", (orgId) ->
    API.getOrgNotificationEntities(orgId)

  App.reqres.setHandler "notification:entities", ->
    API.getNotificationEntities()