@Learnster.module "OrgsApp.List", (List, App, Backbone, Marionette, $, _) ->

    class List.Layout extends App.Views.Layout
        template: "organisations/list/templates/list_layout"

        regions:
            panelRegion:   "#panel-region"
            newRegion:     "#new-region"
            listSettingsRegion: "#list-settings-region"
            searchRegion:  "#search-region"
            orgsRegion:    "#orgs-region"

    class List.Panel extends App.Views.ItemView
        template: "organisations/list/templates/_panel"
        collectionEvents:
            "reset": "render"
        triggers:
            "click #new-org-button" : "new:org:button:clicked"
            "click #list-settings-button" : "settings:button:clicked"

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