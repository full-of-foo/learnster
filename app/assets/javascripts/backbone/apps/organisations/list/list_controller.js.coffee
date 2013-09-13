@Learnster.module "OrgsApp.List", (List, App, Backbone, Marionette, $, _) ->

    class List.Controller extends App.Controllers.Base

        initialize: (options) ->
            App.request "org:entities", (orgs) =>
               
               App.execute "when:fetched", orgs, =>
                    @layout = @getLayoutView()

                    @listenTo @layout, "show", =>
                        @showPanel orgs
                        @showOrgs orgs

                    @show @layout

        showNewRegion: ->
            App.execute "new:org:view", @layout.newRegion

        showPanel: (orgs) ->
            panelView = @getPanelView orgs

            @listenTo panelView, "new:org:button:clicked", =>
                @showNewRegion()

            @layout.panelRegion.show panelView

        showOrgs: (orgs) ->
            orgsView = @getOrgsView orgs

            @listenTo orgsView, "childview:org:clicked", (child, args) ->
                App.vent.trigger "org:clicked", args.model

            @listenTo orgsView, "childview:org:delete:clicked", (child, args) ->
                model = args.model
                if confirm "Are you sure you want to delete #{model.get('title')}?" then model.destroy() else false

            @layout.orgsRegion.show orgsView

        getPanelView: (orgs) ->
            new List.Panel
                collection: orgs

        getOrgsView: (orgs) ->
            new List.Orgs
                collection: orgs


        getLayoutView: ->
            new List.Layout
