@Learnster.module "OrgAdminsApp.List", (List, App, Backbone, Marionette, $, _) ->

    class List.Layout extends App.Views.Layout
        template: "org_admins/list/templates/list_layout"

        regions:
            panelRegion: "#panel-region"
            searchRegion: "#search-region"
            newRegion: "#new-region"
            orgAdminsRegion: "#org-admin-region"

    class List.Panel extends App.Views.ItemView
        template: "org_admins/list/templates/_panel"
        collectionEvents:
            "reset": "render"
        triggers:
            "click #new-org-admin-button" : "new:org_admin:button:clicked"

    class List.SearchPanel extends App.Views.ItemView
        template: "org_admins/list/templates/_search_panel"
        ui:
            "input" : "input"
        events:
            "submit form" : "formSubmitted"
        formSubmitted: (e) ->
            e.preventDefault()
            data = Backbone.Syphon.serialize @
            @trigger "search:submitted", data


    class List.New extends App.Views.ItemView
        template: "org_admins/list/templates/_new"

    class List.OrgAdmin extends App.Views.ItemView
        template: "org_admins/list/templates/_org_admin"
        tagName: "tr"
        triggers:
            "click .delete-icon i"    : "org_admin:delete:clicked"
            "click"                   : "org_admin:clicked"
            "click .org-link"         : "org:clicked"

    class List.Empty extends App.Views.ItemView
        template: "org_admins/list/templates/_empty"
        tagName: "tr"

    class List.OrgAdmins extends App.Views.CompositeView
        onShow: ->
            $("#app-table").tablesorter()

        template: "org_admins/list/templates/_org_admins"
        itemView: List.OrgAdmin
        emptyView: List.Empty
        itemViewContainer: "tbody"
        collectionEvents:
            "reset": "render"