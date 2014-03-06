@Learnster.module "DashApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Controllers.Base

    initialize: (options = {}) ->
      @_nestingOrg = App.request("org:entity", options.id)
      @_nestingOrgId = options.id

      coursesDashBlock = App.request("dash:block:entity", "Courses")
      modulesDashBlock = App.request("dash:block:entity", "Modules")
      contentsDashBlock = App.request("dash:block:entity", "Module Contents")
      notificationsDashBlock = App.request("dash:block:entity", "Notifications")

      user = App.request "get:current:user"

      App.execute "when:fetched", user, =>
        courses       = @getCourses(user)
        modules       = @getModules(user)
        contents      = @getContents(user)
        notifications = @getNotifications(user)


        @layout = @getLayoutView()
        @listenTo @layout, "show", =>
          @showCoursesBlock(coursesDashBlock, courses)
          @showModulesBlock(modulesDashBlock, modules)
          @showContentsBlock(contentsDashBlock, contents)
          @showNotificationsBlock(notificationsDashBlock, notifications)

        @show @layout

    getCourses: (user) ->
      if user.get('type') is 'OrgAdmin'
        return App.request("org:course:entities", @_nestingOrgId)
      else
        return App.request("student:org:course:entities", @_nestingOrgId, user.get('id'))

    getModules: (user) ->
      if user.get('type') is 'OrgAdmin'
        return App.request("learning_module:entities", @_nestingOrgId)
      else
        return App.request("student:learning_module:entities", @_nestingOrgId, user.get('id'))

    getContents: (user) ->
      isManager = @_isManager(user)

      if isManager
        return App.request("educator:content:entities", user.get('id'))
      else if user.get('type') is "Student"
        return App.request("student:content:entities", user.get('id'))
      else
        return App.request("org:supplement:content:entities", @_nestingOrgId)

    getNotifications: (user) ->
      isManager = @_isManager(user)
      opts =
          nestedId:  @_nestingOrgId
          page:      1
          adminId:   user.get('id') if isManager
          studentId: user.get('id') if user.get('type') is "Student"

      return App.request "search:notifications:entities", opts

    _isManager: (user) ->
      (user.get('type') is "OrgAdmin" and (user.
                    get('role') is "course_manager" or user.get('role') is "module_manager"))

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

    showContentsBlock: (contentsDashBlock, contents) ->
      blockView = new List.DashBlockComposite
        model: contentsDashBlock
        collection: contents

      @listenTo blockView, "dash:contents:block:clicked", ->
        App.vent.trigger "modules:block:clicked", @_nestingOrg

      @listenTo blockView, "childview:dash:block:clicked", (child, args) ->
        supplement = App.request "init:module:supplement", args.model.get('module_supplement')
        App.vent.trigger "dash:block:clicked", supplement, @_nestingOrg

      @listenTo blockView, "childview:file:link:clicked", (child, args) ->
        child.$el.unbind('click')
        child.$el.find('i').click()

      @listenTo blockView, "childview:wiki:link:clicked", (child, args) ->
        App.vent.trigger "wiki:content:clicked", args.model

      @show blockView,
        loading:
          loadingType: "spinner"
        region: @layout.contentsBlockRegion

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

