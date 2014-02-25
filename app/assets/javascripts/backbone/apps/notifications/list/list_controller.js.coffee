@Learnster.module "NotificationsApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Controllers.Base

    initialize: (options = {}) ->
      @_nestingOrg = if options.id then App.request("org:entity", options.id) else false
      @_nestingOrgId = if options.id then options.id else false

      notifications = @getNotifications()

      @layout = @getLayoutView()
      @listenTo @layout, "show", =>
        @showNotifications notifications
        @showPanel notifications

      @show @layout

    getNotifications: ->
      user = App.currentUser

      if user instanceof Learnster.Entities.OrgAdmin
        switch user.get('role')
          when "course_manager"  then notifications = App.request("course:manager:notification:entities", @_nestingOrgId, user.get('id'))
          when "module_manager"  then throw new Error
          when "account_manager" then notifications =  App.request("org:notification:entities", @_nestingOrgId)
      else if user instanceof Learnster.Entities.AppAdmin
        notifications = App.request("notification:entities")
      else if user instanceof Learnster.Entities.Student
        throw new Error
      notifications

    showPanel: (notifications) ->
      panelView = @getPanelView notifications

      @layout.panelRegion.show panelView

    showNotifications: (notifications) ->
      notificationsView = @getNotificationsView notifications

      @show notificationsView,
        loading:
          loadingType: "spinner"
        region: @layout.statSummariesRegion

    getPanelView: (notifications) ->
      new List.Panel
        collection: notifications

    getLayoutView: ->
      new List.Layout()

    getNotificationsView: (notifications) ->
      new List.NotificationSummaries
        collection: notifications
