@Learnster.module "StaticApp.Show", (Show, App, Backbone, Marionette, $, _) ->

    class Show.Layout extends App.Views.Layout
      template: "static/show/templates/show_layout"
      regions:
        staticRegion: "#static-region"

    class Show.About extends App.Views.ItemView
      template: "static/show/templates/_about"

    class Show.Testimonials extends App.Views.ItemView
      template: "static/show/templates/_testimonials"
