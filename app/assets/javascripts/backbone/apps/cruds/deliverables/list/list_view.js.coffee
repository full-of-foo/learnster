@Learnster.module "DeliverablesApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Layout extends App.Views.Layout
    template: "deliverables/list/templates/list_layout"
    regions:
      panelRegion: "#panel-region"
      listRegion:  "#list-region"

  class List.Panel extends App.Views.ItemView
    template: "deliverables/list/templates/_panel"
