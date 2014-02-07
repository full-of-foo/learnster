@Learnster.module "DashApp.List", (List, App, Backbone, Marionette, $, _) ->

    class List.Layout extends App.Views.Layout
      template: "dashboard/list/templates/layout"
      regions:
        coursesBlockRegion: "#courses-block-region"
        modulesBlockRegion: "#modules-block-region"
        filesBlockRegion: "#files-block-region"
        notificationsBlockRegion: "#notifications-block-region"

    class List.DashBlock extends App.Views.ItemView
      template: 'dashboard/list/templates/_dash_block'

    class List.DashBlockComposite extends App.Views.CompositeView
      template: 'dashboard/list/templates/_dash_blocks'
      itemView: List.DashBlock
      itemViewContainer: 'ul'
      className: 'dash-block'
      triggers:
        "click div#Courses" : "dash:courses:block:clicked"
