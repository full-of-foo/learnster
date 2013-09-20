@Learnster.module "OrgAdminsApp.List", (List, App, Backbone, Marionette, $, _) ->

    class List.Controller extends App.Controllers.Base

        initialize: (options) ->
            org_admins = App.request "org_admin:entities"
            
            @layout = @getLayoutView()

            @listenTo @layout, "show", =>
                @showSearch org_admins
                @showPanel org_admins
                @showOrgAdmins org_admins

            @show @layout

        showNewRegion: ->
            App.execute "new:org_admin:view", @layout.newRegion

        showPanel: (org_admins) ->
            panelView = @getPanelView org_admins

            @listenTo panelView, "new:org_admin:button:clicked", =>
                @showNewRegion()

            @layout.panelRegion.show panelView

        showSearch: (org_admins) ->
            searchView = @getSearchView org_admins

            @listenTo searchView, "search:submitted", (searchTerm) =>
                @searchOrgAdmins searchTerm
            
            @layout.searchRegion.show searchView

        searchOrgAdmins: (searchTerm = null) ->
            @showSearchOrgAdmins(searchTerm)

        showOrgAdmins: (org_admins) ->
            orgAdminsView = @getOrgAdminsView org_admins

            @listenTo orgAdminsView, "childview:org_admin:clicked", (child, args) ->
                App.vent.trigger "org_admin:clicked", args.model

            @listenTo orgAdminsView, "childview:org:clicked", (child, args) ->
                App.vent.trigger "org:clicked", args.model.get('admin_for').id

            @listenTo orgAdminsView, "childview:org_admin:delete:clicked", (child, args) ->
                model = args.model
                if confirm "Are you sure you want to delete #{model.get('first_name')}?" then model.destroy() else false


            @show orgAdminsView,
                            loading:
                                loadingType: "spinner"
                            region:  @layout.orgAdminsRegion

        showSearchOrgAdmins: (searchTerm) ->
            org_admins = App.request "search:org_admins:entities", searchTerm
            @showOrgAdmins(org_admins)

        getPanelView: (org_admins) ->
            new List.Panel
                collection: org_admins

        getSearchView: (org_admins) ->
            new List.SearchPanel
                collection: org_admins

        getOrgAdminsView: (org_admins) ->
            new List.OrgAdmins
                collection: org_admins

        getLayoutView: ->
            new List.Layout