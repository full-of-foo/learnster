@Learnster.module "StudentsApp.List", (List, App, Backbone, Marionette, $, _) ->

    class List.Layout extends App.Views.Layout
        template: "students/list/templates/list_layout"

        regions:
            panelRegion: "#panel-region"
            searchRegion: "#search-region"
            newRegion: "#new-region"
            studentsRegion: "#students-region"

    class List.Panel extends App.Views.ItemView
        template: "students/list/templates/_panel"
        collectionEvents:
            "reset": "render"
        triggers:
            "click #new-student-button" : "new:student:button:clicked"

    class List.SearchPanel extends App.Views.ItemView
        template: "students/list/templates/_search_panel"
        ui:
            "input" : "input"
        events:
            "submit form" : "formSubmitted"
        formSubmitted: (e) ->
            e.preventDefault()
            data = Backbone.Syphon.serialize @
            @trigger "search:submitted", data


    class List.New extends App.Views.ItemView
        template: "students/list/templates/_new"

    class List.Student extends App.Views.ItemView
        template: "students/list/templates/_student"
        tagName: "tr"
        triggers:
            "click .delete-icon i"    : "student:delete:clicked"
            "click"                   : "student:clicked"
            "click .org-link"         : "org:clicked"

    class List.Empty extends App.Views.ItemView
        template: "students/list/templates/_empty"
        tagName: "tr"

    class List.Students extends App.Views.CompositeView
        onShow: ->
            $("#app-table").tablesorter()

        template: "students/list/templates/_students"
        itemView: List.Student
        emptyView: List.Empty
        itemViewContainer: "tbody"
        collectionEvents:
            "reset": "render"