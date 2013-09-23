@Learnster.module "OrgsApp.List", (List, App, Backbone, Marionette, $, _) ->

    class List.Controller extends App.Controllers.Base

        initialize: (options) ->
            orgs = App.request "org:entities"
               
            @layout = @getLayoutView()

            @listenTo @layout, "show", =>
                @showPanel orgs
                @showSearch orgs
                @showOrgs orgs

            @show @layout

        showNewRegion: ->
            App.execute "new:org:view", @layout.newRegion

        showPanel: (orgs) ->
            panelView = @getPanelView orgs

            @listenTo panelView, "new:org:button:clicked", =>
                @showNewRegion()

            @layout.panelRegion.show panelView

        showSearch: (orgs) ->
            searchView = @getSearchView orgs

            @listenTo searchView, "search:submitted", (searchTerm) =>
                @searchOrgs searchTerm
            
            @layout.searchRegion.show searchView

        searchOrgs: (searchTerm = null) ->
            @showSearchOrgs(searchTerm)

        showOrgs: (orgs) ->
            orgsView = @getOrgsView orgs

            @listenTo orgsView, "childview:org:clicked", (child, args) ->
                App.vent.trigger "org:clicked", args.model

            @listenTo orgsView, "childview:org-students:clicked", (child, args) ->
                App.vent.trigger "list-org-students:clicked", args.model

            @listenTo orgsView, "childview:org-admins:clicked", (child, args) ->
                App.vent.trigger "list-org-admins:clicked", args.model

            @listenTo orgsView, "childview:org:delete:clicked", (child, args) ->
                model = args.model
                if confirm "Are you sure you want to delete #{model.get('title')}?" then model.destroy() else false

            @show orgsView,
                        loading:
                            loadingType: "spinner"
                        region:  @layout.orgsRegion

        showSearchOrgs: (searchTerm) ->
            orgs = App.request "search:orgs:entities", searchTerm
            @showOrgs orgs

        getPanelView: (orgs) ->
            new List.Panel
                collection: orgs

        getSearchView: (orgs) ->
            new List.SearchPanel
                collection: orgs

        getOrgsView: (orgs) ->
            new List.Orgs
                collection: orgs


        getLayoutView: ->
            new List.Layout
