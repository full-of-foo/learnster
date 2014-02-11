@Learnster.module "DashApp.List", (List, App, Backbone, Marionette, $, _) ->

    class List.Layout extends App.Views.Layout
      template: "dashboard/list/templates/layout"
      regions:
        coursesBlockRegion: "#courses-block-region"
        modulesBlockRegion: "#modules-block-region"
        filesBlockRegion: "#files-block-region"
        notificationsBlockRegion: "#notifications-block-region"

    class List.EmptyCourseBlock extends App.Views.ItemView
      template: 'dashboard/list/templates/_empty_courses'
      triggers:
        "click a#add-course-link" : "clicked:add:course:link"

    class List.EmptyModuleBlock extends App.Views.ItemView
      template: 'dashboard/list/templates/_empty_modules'
      triggers:
        "click a#add-course-link" : "clicked:add:course:link"

    class List.EmptyFileBlock extends App.Views.ItemView
      template: 'dashboard/list/templates/_empty_files'

    class List.EmptyNotificationBlock extends App.Views.ItemView
      template: 'dashboard/list/templates/_empty_notification'

    class List.DashBlock extends App.Views.ItemView
      template: 'dashboard/list/templates/_dash_block'

    class List.DashBlockComposite extends App.Views.CompositeView
      template: 'dashboard/list/templates/_dash_blocks'
      itemView: List.DashBlock
      itemViewContainer: 'ul'
      className: 'dash-block'

      initialize: (options = {}) ->
        @['emptyView'] = List.EmptyCourseBlock if @collection instanceof App.Entities.CourseCollection
        @['emptyView'] = List.EmptyModuleBlock if @collection instanceof App.Entities.LearningModuleCollection
        # TODO - update w/ file entity
        @['emptyView'] = List.EmptyFileBlock if @collection instanceof App.Entities.NotificationsCollection
        @['emptyView'] = List.EmptyNotificationBlock if @collection instanceof App.Entities.NotificationsCollection

      triggers:
        "click div#Courses" : "dash:courses:block:clicked"
        "click div#Modules" : "dash:modules:block:clicked"
        "click div#Notifications" : "dash:notifications:block:clicked"
