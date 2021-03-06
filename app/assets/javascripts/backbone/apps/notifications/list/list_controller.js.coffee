@Learnster.module "NotificationsApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Controllers.Base

    initialize: (options = {}) ->
      @_nestingOrg = if options.id then App.request("org:entity", options.id) else false
      @_nestingOrgId = if options.id then options.id else false

      user = App.currentUser

      App.execute "when:fetched", user, =>
        notifications = @getNotifications(user)

        @layout = @getLayoutView()
        @listenTo @layout, "show", =>
          @showNotifications notifications
          @showPanel notifications

        @show @layout


    getNotifications: (user) ->
      if user instanceof Learnster.Entities.OrgAdmin
        switch user.get('role')
          when "course_manager"  then notifications = App.request("manager:notification:entities", @_nestingOrgId, user.get('id'))
          when "module_manager"  then notifications = App.request("manager:notification:entities", @_nestingOrgId, user.get('id'))
          when "account_manager" then notifications =  App.request("org:notification:entities", @_nestingOrgId)
      else if user instanceof Learnster.Entities.AppAdmin
        notifications = App.request("notification:entities")
      else if user instanceof Learnster.Entities.Student
        notifications = App.request("student:notification:entities", @_nestingOrgId, user.get('id'))
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
      listView = App.request "list:wrapper", notifications,
        config:
          emptyMessage: "no notifications just quite yet"
          listClassName: "notifications"
          listItemTemplate: "backbone/apps/notifications/list/templates/_notification_summary"
          itemProperties:
            triggers:
              "click span" : "notification:clicked"
      listView
