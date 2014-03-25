@Learnster.module "CoursesApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Controllers.Base

    initialize: (options) ->
      @_isMyCourses  = options.isMyCourses
      @_nestingOrgId = if options.id then options.id else false
      @_nestingOrg   = if @_nestingOrgId then App.request("org:entity", @_nestingOrgId) else false

      App.execute "when:fetched", App.currentUser, =>
        courses = @getCourses()
        @layout = @getLayoutView()

        @listenTo @layout, "show", =>
          @showSearch courses
          @showPanel courses
          @showCourses courses

        @show @layout

    getCourses: ->      
      if not @_isMyCourses
        courses = App.request("org:course:entities", @_nestingOrgId)
      else if(App.currentUser.get('type') is "OrgAdmin")
        courses = App.request("admin:org:course:entities", @_nestingOrgId, App.currentUser.get('id'))
      else if(App.currentUser.get('type') is "Student")
        courses = App.request("student:org:course:entities", @_nestingOrgId, App.currentUser.get('id'))
      courses

    showNewRegion: ->
      @layout.newRegion['_nestingOrg'] = @_nestingOrg
      App.execute "new:course:view", @layout.newRegion

    showPanel: (courses) ->
      if @_isMyCourses
        panelView = @getMyPanelView courses
      else
        panelView = @getPanelView courses

      @listenTo panelView, "new:course:button:clicked", =>
          @showNewRegion()

      @layout.panelRegion.show panelView

    showSearch: (courses) ->
      searchView = @getSearchView courses

      @listenTo searchView, "search:submitted", (searchTerm) =>
        @searchCourses searchTerm

      @layout.searchRegion.show searchView

    searchCourses: (searchTerm) ->
      myId = App.currentUser.get('id')

      searchOpts =
        nestedId: @_nestingOrg?.id
        term: searchTerm
        managedId: myId if @_isMyCourses and App.currentUser.get('type') is "OrgAdmin"
        studiedId: myId if @_isMyCourses and App.currentUser.get('type') is "Student"

      @showSearchCourses(searchOpts)

    showCourses: (courses) ->
      cols = @getTableColumns()
      options = @getTableOptions cols

      @coursesView = App.request "table:wrapper", courses, options

      @listenTo @coursesView, "childview:course:clicked", (child, args) ->
        App.vent.trigger "course:clicked", args.model

      @listenTo @coursesView, "childview:course:delete:clicked", (child, args) ->
        model = args.model
        dialogView = @getDialogView model
        @listenTo dialogView, "dialog:delete:course:clicked", =>
          dialogView.$el.modal "hide"
          model.destroy()
          model.on "destroy", ( => @showFetchedCourses())

        @show dialogView,
          loading:
            loadingType: "spinner"
          region: App.dialogRegion

      @show @coursesView,
        loading:
          loadingType: "spinner"
        region:  @layout.coursesRegion

    showSearchCourses: (searchOpts) ->
      courses = App.request "search:courses:entities", searchOpts
      @showCourses(courses)

    showFetchedCourses: ->
      courses = @getCourses()
      @showCourses(courses)

    getPanelView: (courses) ->
      new List.Panel
        collection: courses
        templateHelpers:
          nestingOrg: @_nestingOrg

    getMyPanelView: (courses) ->
      new List.MyPanel
        collection: courses
        templateHelpers:
          nestingOrg: @_nestingOrg

    getSearchView: (courses) ->
      new List.SearchPanel
        collection: courses
        templateHelpers:
          nestingOrg: @_nestingOrg

    getDialogView: (course) ->
      new List.DeleteDialog
        model: course

    getLayoutView: ->
      new List.Layout

    getTableColumns: ->
      [
       { title: "Title", attrName: "title", isSortable: true, isRemovable: false, default: true },
       { title: "Description", attrName: "description", default: true, isRemovable: false },
       { title: "Identifier", attrName: "identifier", isSortable: true, isRemovable: false, default: true },
       { title: "# Sections", htmlContent: '<%= model.get("section_count") %>', default: true,  isSortable: true, isRemovable: false },
       { title: "Manager", attrName: "managed_by.full_name", isSortable: true, isRemovable: false, default: true },
       { htmlContent: '<% if ( (currentUser.get("type") ===  "OrgAdmin" && currentUser.get("role") ===  "account_manager")
                                || currentUser.get("type") ===  "AppAdmin" ) { %>
        <div class="delete-icon"><i class="icon-remove-sign"></i></div>
        <% } %>', className: "last-col-invisible", default: true, isRemovable: false }
      ]

    getTableOptions: (columns) ->
      columns: columns
      region: @layout.coursesRegion
      config:
        emptyMessage: "No courses found :("
        itemProperties:
          triggers:
            "click .delete-icon i"   : "course:delete:clicked"
            "click"                  : "course:clicked"
            "click .org-link"        : "org:clicked"
