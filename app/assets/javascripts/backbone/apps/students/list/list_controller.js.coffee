@Learnster.module "StudentsApp.List", (List, App, Backbone, Marionette, $, _) ->

    class List.Controller extends App.Controllers.Base

        initialize: (options) ->
            students = App.request "student:entities"
            
            @layout = @getLayoutView()

            @listenTo @layout, "show", =>
                @showSearch students
                @showPanel students
                @showStudents students

            @show @layout

        showNewRegion: ->
            App.execute "new:student:view", @layout.newRegion

        showPanel: (students) ->
            panelView = @getPanelView students

            @listenTo panelView, "new:student:button:clicked", =>
                @showNewRegion()

            @layout.panelRegion.show panelView

        showSearch: (students) ->
            searchView = @getSearchView students

            @listenTo searchView, "search:submitted", (searchTerm) =>
                @searchStudents searchTerm
            
            @layout.searchRegion.show searchView

        searchStudents: (searchTerm = null) ->
            @showSearchStudents(searchTerm)

        showStudents: (students) ->
            studentsView = @getStudentsView students

            @listenTo studentsView, "childview:student:clicked", (child, args) ->
                App.vent.trigger "student:clicked", args.model

            @listenTo studentsView, "childview:student:delete:clicked", (child, args) ->
                model = args.model
                if confirm "Are you sure you want to delete #{model.get('first_name')}?" then model.destroy() else false


            @show studentsView,
                            loading:
                                loadingType: "spinner"
                            region:  @layout.studentsRegion

        showSearchStudents: (searchTerm) ->
            students = App.request "search:students:entities", searchTerm
            @showStudents(students)

        getPanelView: (students) ->
            new List.Panel
                collection: students

        getSearchView: (students) ->
            new List.SearchPanel
                collection: students

        getStudentsView: (students) ->
            new List.Students
                collection: students

        getLayoutView: ->
            new List.Layout