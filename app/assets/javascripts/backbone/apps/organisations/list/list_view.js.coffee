@Learnster.module "OrgsApp.List", (List, App, Backbone, Marionette, $, _) ->

    class List.Layout extends App.Views.Layout
        template: "organisations/list/templates/list_layout"

        regions:
            panelRegion: "#panel-region"
            newRegion: "#new-region"
            orgsRegion: "#orgs-region"

    class List.Panel extends App.Views.ItemView
        template: "organisations/list/templates/_panel"
        collectionEvents:
            "reset": "render"
        triggers:
            "click #new-org-button" : "new:org:button:clicked"

    class List.Org extends App.Views.ItemView
        template: "organisations/list/templates/_org"
        tagName: "tr"
        triggers:
            "click .delete-icon i"    : "org:delete:clicked"
            "click"                   : "org:clicked"

    class List.Empty extends App.Views.ItemView
        template: "organisations/list/templates/_empty"
        tagName: "tr"

    class List.Orgs extends App.Views.CompositeView
        template: "organisations/list/templates/_orgs"
        itemView: List.Org
        emptyView: List.Empty
        itemViewContainer: "tbody"
        collectionEvents:
            "reset": "render"