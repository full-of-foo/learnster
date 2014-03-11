@Learnster.module "NotificationsApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.Views.Layout
    template: "notifications/list/templates/layout"
    regions:
      panelRegion: "#panel-region"
      statSummariesRegion: "#notifications-region"

  class List.Panel extends App.Views.ItemView
    template: "notifications/list/templates/_panel"

