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
        data:
          page: 1
      notifications

    getOrgNotificationEntities: (id) ->
      notifications = new Entities.NotificationsCollection
        url: Routes.api_organisation_activities_path(id)
      notifications.fetch
        reset: true
        data:
          page: 1
      notifications

    getManagerNotificationEntities: (orgId, adminId) ->
      notifications = new Entities.NotificationsCollection
        url: Routes.api_organisation_activities_path(orgId)
      notifications.fetch
        reset: true
        data:
          manager_id: adminId
          page: 1

      notifications

    getStudentNotificationEntities: (orgId, studentId) ->
      notifications = new Entities.NotificationsCollection
        url: Routes.api_organisation_activities_path(orgId)
      notifications.fetch
        reset: true
        data:
          student_id: studentId
          page: 1

      notifications

    getSearchNotificationEntities: (searchOpts) ->
      { term, nestedId, page, adminId, studentId } = searchOpts
      opts = {}
      opts['page']       = page if page
      opts['search']     = term if term
      opts['manager_id'] = adminId if adminId
      opts['student_id'] = studentId if studentId

      if nestedId
        notifications = new Entities.NotificationsCollection
          url: Routes.api_organisation_activities_path(nestedId)
      else
        notifications = new Entities.NotificationsCollection()
      notifications.fetch
        reset: true
        data: $.param(opts)

      notifications.put('search', term['search']) if term
      notifications



  App.reqres.setHandler "org:notification:entities", (orgId) ->
    API.getOrgNotificationEntities(orgId)

  App.reqres.setHandler "manager:notification:entities", (orgId, adminId) ->
    API.getManagerNotificationEntities(orgId, adminId)

  App.reqres.setHandler "student:notification:entities", (orgId, studentId) ->
    API.getStudentNotificationEntities(orgId, studentId)

  App.reqres.setHandler "notification:entities", ->
    API.getNotificationEntities()

  App.reqres.setHandler "search:notifications:entities", (searchOpts) ->
    API.getSearchNotificationEntities searchOpts
