@Learnster.module "DashApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Controllers.Base

    initialize: (options = {}) ->
      @_nestingOrg = App.request("org:entity", options.id)

      coursesDashBlock = App.request("dash:block:entity", "Courses")
      modulesDashBlock = App.request("dash:block:entity", "Modules")
      filesDashBlock = App.request("dash:block:entity", "Files")
      notificationsDashBlock = App.request("dash:block:entity", "Notifications")

      #TODO = fetch type of entity
      opts =
        nestedId: @_nestingOrg.get('id')
        page:     1

      courses = App.request "course:entities", opts.nestedId
      modules = App.request "learning_module:entities", opts.nestedId
      files = App.request "search:notifications:entities", opts
      notifications = App.request "search:notifications:entities", opts


      @layout = @getLayoutView()
      @listenTo @layout, "show", =>
        @showCoursesBlock(coursesDashBlock, courses)
        @showModulesBlock(modulesDashBlock, modules)
        @showFilesBlock(filesDashBlock, files)
        @showNotificationsBlock(notificationsDashBlock, notifications)

      @show @layout

    getLayoutView: ->
      new List.Layout()

    showCoursesBlock: (coursesDashBlock, courses) ->
      blockView = new List.DashBlockComposite
        model: coursesDashBlock
        collection: courses

      @show blockView,
        loading:
          loadingType: "spinner"
        region: @layout.coursesBlockRegion

    showModulesBlock: (modulesDashBlock, modules) ->
      blockView = new List.DashBlockComposite
        model: modulesDashBlock
        collection: modules

      @show blockView,
        loading:
          loadingType: "spinner"
        region: @layout.modulesBlockRegion

    showFilesBlock: (filesDashBlock, files) ->
      blockView = new List.DashBlockComposite
        model: filesDashBlock
        collection: files

      @show blockView,
        loading:
          loadingType: "spinner"
        region: @layout.filesBlockRegion

    showNotificationsBlock: (notificationsDashBlock, notifications) ->
      blockView = new List.DashBlockComposite
        model: notificationsDashBlock
        collection: notifications

      @show blockView,
        loading:
          loadingType: "spinner"
        region: @layout.notificationsBlockRegion

