@Learnster.module "HeaderApp.Show", (Show, App, Backbone, Marionette, $, _) ->

    class Show.Layout extends App.Views.Layout
      template: "header/show/templates/layout"
      regions:
        dockRegion:    "#dock-region"
        logoutRegion:  "#logout-region"
        subLogoRegion: "#sub-logo-region"

    class Show.SubLogo extends App.Views.ItemView
      template: "header/show/templates/sub_logo"


