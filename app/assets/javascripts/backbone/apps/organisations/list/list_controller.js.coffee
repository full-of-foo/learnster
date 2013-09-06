@Learnster.module "OrgsApp.List", (List, App, Backbone, Marionette, $, _) ->

    List.Controller =

        listOrgs: ->
            App.request "org:entities", (orgs) =>
               
               App.execute "when:fetched", orgs, =>
                    @layout = @getLayoutView()

                    @layout.on "show", =>
                        @showPanel orgs
                        @showOrgs orgs

                    App.mainRegion.show @layout

        showNewRegion: ->
            newView = App.request "new:org:view"
            region = @layout.newRegion

            newView.on "form:cancel:button:clicked", =>
                region.close()

            region.show newView

        showPanel: (orgs) ->
            panelView = @getPanelView orgs

            panelView.on "new:org:button:clicked", =>
                @showNewRegion()

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
