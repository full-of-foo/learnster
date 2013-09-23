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

            @show panelView,
                        loading:
                            loadingType: "spinner"
                        region:  @layout.panelRegion

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
            studentsView = @getStudentsView students

            @listenTo studentsView, "childview:student:clicked", (child, args) ->
                App.vent.trigger "student:clicked", args.model

            @listenTo studentsView, "childview:org:clicked", (child, args) ->
                App.vent.trigger "org:clicked", args.model.get('attending_org').id

            @listenTo studentsView, "childview:student:delete:clicked", (child, args) ->
                model = args.model
                if confirm "Are you sure you want to delete #{model.get('first_name')}?" then model.destroy() else false


            @show studentsView,
                            loading:
                                loadingType: "spinner"
                            region:  @layout.studentsRegion

        showSearchStudents: (searchOpts) ->
            students = App.request "search:students:entities", searchOpts
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

        getStudentsView: (students) ->
            new List.Students
                collection: students
                templateHelpers:
                        nestingOrg: @_nestingOrg

        getLayoutView: ->
            new List.Layout
            