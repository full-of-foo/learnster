@Learnster.module "NotificationsApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Controllers.Base

    initialize: (options = {}) ->
      notifications = App.request "notification:entities"

      @layout = @getLayoutView()
      console.log @layout
      @listenTo @layout, "show", =>
        @showNotifications notifications
        @showPanel notifications

      @show @layout

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