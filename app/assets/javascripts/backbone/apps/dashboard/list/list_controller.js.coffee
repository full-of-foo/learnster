@Learnster.module "DashApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Controllers.Base

    initialize: (options = {}) ->
      @_nestingOrg = App.request("org:entity", options.id)

      coursesDashBlock = App.request("dash:block:entity", "Courses")
      modulesDashBlock = App.request("dash:block:entity", "Modules")
      filesDashBlock = App.request("dash:block:entity", "Module Files")
      notificationsDashBlock = App.request("dash:block:entity", "Notifications")

      #TODO = fetch type of entity
      opts =
        nestedId: @_nestingOrg.get('id')
        page:     1

      courses = App.request "org:course:entities", opts.nestedId
      modules = App.request "learning_module:entities", opts.nestedId
      files = App.request "org:supplement:content:entities", opts.nestedId
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

      @listenTo blockView, "dash:courses:block:clicked", ->
        App.vent.trigger "courses:block:clicked", @_nestingOrg

      @listenTo blockView, "childview:clicked:add:course:link", (arg, model) ->
        App.vent.trigger "clicked:add:course", @_nestingOrg

      @listenTo blockView, "childview:dash:block:clicked", (child, args) ->
        App.vent.trigger "dash:block:clicked", args.model, @_nestingOrg

      @show blockView,
        loading:
          loadingType: "spinner"
        region: @layout.coursesBlockRegion

    showModulesBlock: (modulesDashBlock, modules) ->
      blockView = new List.DashBlockComposite
        model: modulesDashBlock
        collection: modules

      @listenTo blockView, "dash:modules:block:clicked", ->
        App.vent.trigger "modules:block:clicked", @_nestingOrg

      @listenTo blockView, "childview:clicked:add:module:link", (arg, model) ->
        App.vent.trigger "clicked:add:module", @_nestingOrg

      @listenTo blockView, "childview:dash:block:clicked", (child, args) ->
        App.vent.trigger "dash:block:clicked", args.model, @_nestingOrg

      @show blockView,
        loading:
          loadingType: "spinner"
        region: @layout.modulesBlockRegion

    showFilesBlock: (filesDashBlock, files) ->
      blockView = new List.DashBlockComposite
        model: filesDashBlock
        collection: files

      @listenTo blockView, "dash:files:block:clicked", ->
        App.vent.trigger "modules:block:clicked", @_nestingOrg

      @listenTo blockView, "childview:dash:block:clicked", (child, args) ->
        supplement = App.request "init:module:supplement", args.model.get('module_supplement')
        App.vent.trigger "dash:block:clicked", supplement, @_nestingOrg

      @listenTo blockView, "childview:file:link:clicked", (child, args) ->
        child.$el.unbind('click')
        child.$el.find('i').click()

      @show blockView,
        loading:
          loadingType: "spinner"
        region: @layout.filesBlockRegion

    showNotificationsBlock: (notificationsDashBlock, notifications) ->
      blockView = new List.DashBlockComposite
        model: notificationsDashBlock
        collection: notifications

      @listenTo blockView, "dash:notifications:block:clicked", ->
        App.vent.trigger "notifications:block:clicked", @_nestingOrg

      @show blockView,
        loading:
          loadingType: "spinner"
        region: @layout.notificationsBlockRegion

