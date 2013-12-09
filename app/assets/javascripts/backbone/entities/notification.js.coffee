@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Notification extends Entities.Models
    urlRoot: Routes.api_activities_path()

  class Entities.NotificationsCollection extends Entities.Collections
    model: Entities.Notification

    initialize: (options = {}) =>
      @url = if not options.url then Routes.api_activities_path() else options.url
      super

  API =
    getNotificationEntities: ->
      notifications = new Entities.NotificationsCollection
      notifications.fetch
        reset: true
      notifications

    getOrgNotificationEntities: (id) ->
      notifications = new Entities.NotificationsCollection
        url: Routes.api_organisation_activities_path(id)
      notifications.fetch
        reset: true
      notifications

  App.reqres.setHandler "org:notification:entities", (orgId) ->
    API.getOrgNotificationEntities(orgId)

  App.reqres.setHandler "notification:entities", ->
    API.getNotificationEntities()