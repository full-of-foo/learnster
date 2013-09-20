@Learnster.module "OrgsApp.List", (List, App, Backbone, Marionette, $, _) ->

    class List.Layout extends App.Views.Layout
        template: "organisations/list/templates/list_layout"

        regions:
            panelRegion:   "#panel-region"
            newRegion:     "#new-region"
            searchRegion:  "#search-region"
            orgsRegion:    "#orgs-region"

    class List.Panel extends App.Views.ItemView
        template: "organisations/list/templates/_panel"
        collectionEvents:
            "reset": "render"
        triggers:
            "click #new-org-button" : "new:org:button:clicked"

     class List.SearchPanel extends App.Views.ItemView
        template: "organisations/list/templates/_search_panel"
        ui:
            "input" : "input"
        events:
            "submit form" : "formSubmitted"
        formSubmitted: (e) ->
            e.preventDefault()
            data = Backbone.Syphon.serialize @
            @trigger "search:submitted", data

    class List.Org extends App.Views.ItemView
        template: "organisations/list/templates/_org"
        tagName: "tr"
        triggers:
            "click .org-student-count"  : "org-students:clicked"
            "click .delete-icon i"      : "org:delete:clicked"
            "click"                     : "org:clicked"

    class List.Empty extends App.Views.ItemView
        template: "organisations/list/templates/_empty"
        tagName: "tr"

    class List.Orgs extends App.Views.CompositeView
        onShow: ->
            $("#app-table").tablesorter()
            
        template: "organisations/list/templates/_orgs"
        itemView: List.Org
        emptyView: List.Empty
        itemViewContainer: "tbody"
        collectionEvents:
            "reset": "render"