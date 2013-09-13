@Learnster.module "StudentsApp.List", (List, App, Backbone, Marionette, $, _) ->

    class List.Controller extends App.Controllers.Base

        initialize: (options) ->
            App.request "student:entities", (students) =>
                App.execute "when:fetched", students, =>
                    @layout = @getLayoutView()

                    @listenTo @layout, "show", =>
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

        showStudents: (students) ->
            studentsView = @getStudentsView students

            @listenTo studentsView, "childview:student:clicked", (child, args) ->
                console.log args
                App.vent.trigger "student:clicked", args.model

            @listenTo studentsView, "childview:student:delete:clicked", (child, args) ->
                model = args.model
                console.log args
                if confirm "Are you sure you want to delete #{model.get('first_name')}?" then model.destroy() else false

            @layout.studentsRegion.show studentsView

        getPanelView: (students) ->
            new List.Panel
                collection: students

        getStudentsView: (students) ->
            new List.Students
                collection: students

        getLayoutView: ->
            new List.Layout