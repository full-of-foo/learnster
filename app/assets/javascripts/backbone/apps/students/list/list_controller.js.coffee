@Learnster.module "StudentsApp.List", (List, App, Backbone, Marionette, $, _) ->

    class List.Controller extends App.Controllers.Base

        initialize: (options = {}) ->
            @_nestingOrg = if options.id then App.request("org:entity", options.id) else false

            students = if not @_nestingOrg then App.request("student:entities") else App.request("org:student:entities", options.id)
            
            @layout = @getLayoutView()

            @listenTo @layout, "show", =>
                @showSearch students
                @showPanel @_nestingOrg
                @showStudents students

            @show @layout

        showNewRegion: ->
            @layout.newRegion['_nestingOrg'] = @_nestingOrg
            App.execute "new:student:view", @layout.newRegion

        showPanel: (students) ->
            panelView = @getPanelView students

            @listenTo panelView, "new:student:button:clicked", =>
                @showNewRegion()

            @listenTo panelView, "settings:button:clicked", =>
                @showSettings()

            @show panelView,
                        loading:
                            loadingType: "spinner"
                        region:  @layout.panelRegion

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
                term:     searchTerm

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
                model = args.model
                if confirm "Are you sure you want to delete #{model.get('first_name')}?" then model.destroy() else false


            @show @studentsView,
                            loading:
                                loadingType: "spinner"
                            region:  @layout.studentsRegion

        showSearchStudents: (searchOpts) ->
            students = App.request "search:students:entities", searchOpts
            @colCollection = null
            @showSettings() if not @layout.listSettingsRegion.currentView?.isClosed and @layout.listSettingsRegion.currentView
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

        getLayoutView: ->
            new List.Layout

        getTableColumns: ->
            [
             { title: "Name", htmlContent: '<% if ( model.get("is_active") ) 
                { %><i class="icon-list-online-status" title="Online"></i>
                <% } else { %><i class="icon-list-offline-status" title="Offline"></i>
                <% } %><%= model.get("full_name") %>', isSortable: true, default: true, isRemovable: false }
             { title: "Email", attrName: "email", isSortable: true, default: true },
             { title: "Last Online", attrName: "last_login_formatted", default: true},
             { title: "Organisation", htmlContent: '<a href="#" class="org-link">
                <% if ( model.get("attending_org") ) { %><%= model.get("attending_org").title %><% } %></a>', className: "wrap-text", isSortable: true, default: true },
             { title: "Created On", attrName: "created_at_formatted",  isSortable: true },
             { title: "Last Updated", attrName: "updated_at_formatted"},
             { htmlContent: "<div class='delete-icon'><i class='icon-remove-sign'></i></div>", className: "last-col-invisible", default: true, isRemovable: false, hasData: false }
            ]

        getTableOptions: (columns) ->
            columns: columns 
            region:  @layout.studentsRegion
            config:
                emptyMessage: "No students found :("
                itemProperties:
                    triggers:
                        "click .delete-icon i"    : "student:delete:clicked"
                        "click"                   : "student:clicked"
                        "click .org-link"         : "org:clicked"
