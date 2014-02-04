@Learnster.module "StudentsApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Controllers.Base

    initialize: (options = {}) ->
      @_nestingOrgId = if options.id then options.id else false
      @_nestingOrg = if @_nestingOrgId then App.request("org:entity", @_nestingOrgId) else false

      students = if not @_nestingOrg then App.request("student:entities") else App.request("org:student:entities", @_nestingOrgId)

      @layout = @getLayoutView()

      @listenTo @layout, "show", =>
        @showSearch students
        @showPanel students
        @showStudents students

      @show @layout

    showNewRegion: ->
      @layout.newRegion['_nestingOrg'] = @_nestingOrg
      App.execute "new:student:view", @layout.newRegion

    showPanel: (students) ->
      panelView = @getPanelView @_nestingOrg

      @listenTo panelView, "new:student:button:clicked", =>
        @showNewRegion()

      @listenTo panelView, "settings:button:clicked", =>
        @showSettings()

      if @_nestingOrg
        @listenTo panelView, "import:dropdown:clicked", =>
          App.vent.trigger "open:student:import:dialog", @_nestingOrg

          App.vent.on "students:import:success", (dialogView) =>
            @showFetchedStudents()

      @show panelView,
        loading:
          loadingType: "spinner"
        region: @layout.panelRegion

    showSettings: ->
      listCols = @getTableColumns()
      @colCollection = @colCollection || App.request "table:column:entities", listCols, false
      settingsView = App.request "settings:view", @colCollection

      @listenTo settingsView, "childview:setting:col:clicked", (child, args) =>
        column = args.model
        @studentsView.toggleColumn(child, column)

      @show settingsView,
        loading:
          loadingType: "spinner"
        region:  @layout.listSettingsRegion

    showSearch: (students) ->
      searchView = @getSearchView students

      @listenTo searchView, "search:submitted", (searchTerm) =>
        @searchStudents searchTerm

      @show searchView,
        loading:
          loadingType: "spinner"
        region:  @layout.searchRegion


    searchStudents: (searchTerm) ->
      searchOpts =
        nestedId: @_nestingOrg?.id
        term: searchTerm

      @showSearchStudents(searchOpts)

    showStudents: (students) ->
      cols = @getTableColumns()
      options = @getTableOptions cols

      @studentsView = App.request "table:wrapper", students, options

      @listenTo @studentsView, "childview:student:clicked", (child, args) ->
        App.vent.trigger "student:clicked", args.model

      @listenTo @studentsView, "childview:org:clicked", (child, args) ->
        App.vent.trigger "org:clicked", args.model.get('attending_org').id

      @listenTo @studentsView, "childview:student:delete:clicked", (child, args) ->
        dialogView = @getDialogView args.model

        @listenTo dialogView, "dialog:delete:student:clicked", =>
          dialogView.$el.modal "hide"
          args.model.destroy()

        @show dialogView,
          loading:
            loadingType: "spinner"
          region: App.dialogRegion

      @show @studentsView,
        loading:
          loadingType: "spinner"
        region:  @layout.studentsRegion

    showSearchStudents: (searchOpts) ->
      students = App.request "search:students:entities", searchOpts
      @colCollection = null
      @showSettings() if not @layout.listSettingsRegion.currentView?.isClosed and @layout.listSettingsRegion.currentView
      @showStudents(students)

    showFetchedStudents: ->
      console.log @_nestingOrg
      console.log @_nestingOrgId
      students = if not @_nestingOrg then App.request("student:entities") else App.request("org:student:entities", @_nestingOrgId)
      @colCollection = null
      @showSettings() if not @layout.listSettingsRegion?.currentView?.isClosed and @layout.listSettingsRegion?.currentView
      @showStudents(students)

    getPanelView: (students) ->
      new List.Panel
        collection: students
        templateHelpers:
          nestingOrg: @_nestingOrg

    getSearchView: (students) ->
      new List.SearchPanel
        collection: students
        templateHelpers:
          nestingOrg: @_nestingOrg

    getDialogView: (student) ->
      new List.DeleteDialog
        model: student

    getLayoutView: ->
      new List.Layout

    getTableColumns: ->
      cols = [
       { title: "Name", htmlContent: '<% if ( model.get("is_active") )
          { %><i class="icon-list-online-status" title="Online"></i>
          <% } else { %><i class="icon-list-offline-status" title="Offline"></i>
          <% } %><%= model.get("full_name") %>', isSortable: true, default: true, isRemovable: false }
       { title: "Email", attrName: "email", isSortable: true, default: true },
       { title: "Last Online", attrName: "last_login_formatted", default: true},
       { title: "Created On", attrName: "created_at_formatted",  isSortable: true },
       { title: "Last Updated", attrName: "updated_at_formatted"},
       { htmlContent: '<% if ( model.get("created_by") && model.get("created_by").id === currentUser.get("id")
        || currentUser.get("type") ===  "AppAdmin" ) { %>
        <div class="delete-icon"><i class="icon-remove-sign"></i></div>
        <% } %>
      ', className: "last-col-invisible", default: true, isRemovable: false, hasData: false }
      ]
      organisationCol = { title: "Organisation", htmlContent: '<a href="#" class="org-link">
        <% if ( model.get("attending_org") ) { %><%= model.get("attending_org").title %><% }
        %></a>', className: "wrap-text", isSortable: true, default: true }

      user = App.request "get:current:user"
      cols.insertAt(3, organisationCol) if user instanceof Learnster.Entities.AppAdmin
      cols

    getTableOptions: (columns) ->
      columns: columns
      region: @layout.studentsRegion
      config:
        emptyMessage: "No students found :("
        itemProperties:
          triggers:
              "click .delete-icon i"   : "student:delete:clicked"
              "click"                  : "student:clicked"
              "click .org-link"        : "org:clicked"
