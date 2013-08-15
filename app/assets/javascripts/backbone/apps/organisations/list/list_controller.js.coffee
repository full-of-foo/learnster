@Learnster.module "OrgsApp.List", (List, App, Backbone, Marionette, $, _) ->

    List.Controller =

        listOrgs: ->
            App.request "org:entities", (orgs) =>
                @layout = @getLayoutView()

                @layout.on "show", =>
                    @showPanel orgs
                    @showOrgs orgs

                App.mainRegion.show @layout

        showPanel: (orgs) ->
            panelView = @getPanelView orgs
            @layout.panelRegion.show panelView

        showOrgs: (orgs) ->
            orgsView = @getOrgsView orgs
            @layout.orgsRegion.show orgsView

        getPanelView: (orgs) ->
            new List.Panel
                collection: orgs

        getOrgsView: (orgs) ->
            new List.Orgs
                collection: orgs


        getLayoutView: ->
            new List.Layout
