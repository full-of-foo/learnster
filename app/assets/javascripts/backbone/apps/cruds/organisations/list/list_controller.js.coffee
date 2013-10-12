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

            @listenTo panelView, "settings:button:clicked", =>
                @showSettings()

            @layout.panelRegion.show panelView


        showSettings: ->
            listCols = @getTableColumns()
            @colCollection = @colCollection || App.request "table:column:entities", listCols, false
            settingsView = App.request "settings:view", @colCollection 

            @listenTo settingsView, "childview:setting:col:clicked", (child, args) =>
                column = args.model
                @orgsView.toggleColumn(child, column)
                                      
            @show settingsView,
                            loading:
                                loadingType: "spinner"
                            region:  @layout.listSettingsRegion

        showSearch: (orgs) ->
            searchView = @getSearchView orgs

            @listenTo searchView, "search:submitted", (searchTerm) =>
                @searchOrgs searchTerm
            
            @layout.searchRegion.show searchView

        searchOrgs: (searchTerm = null) ->
            @showSearchOrgs(searchTerm)

        showOrgs: (orgs) ->
            cols = @getTableColumns()
            options = @getTableOptions cols

            @orgsView = App.request "table:wrapper", orgs, options

            @listenTo @orgsView, "childview:org:clicked", (child, args) ->
                App.vent.trigger "org:clicked", args.model

            @listenTo @orgsView, "childview:org-students:clicked", (child, args) ->
                App.vent.trigger "list-org-students:clicked", args.model

            @listenTo @orgsView, "childview:org-admins:clicked", (child, args) ->
                App.vent.trigger "list-org-admins:clicked", args.model

            @listenTo @orgsView, "childview:org:delete:clicked", (child, args) ->
                model = args.model
                if confirm "Are you sure you want to delete #{model.get('title')}?" then model.destroy() else false

            @show @orgsView,
                        loading:
                            loadingType: "spinner"
                        region:  @layout.orgsRegion

        showSearchOrgs: (searchTerm) ->
            orgs = App.request "search:orgs:entities", searchTerm
            @colCollection = null
            @showSettings() if not @layout.listSettingsRegion.currentView?.isClosed and @layout.listSettingsRegion.currentView
            @showOrgs orgs

        getPanelView: (orgs) ->
            new List.Panel
                collection: orgs

        getSearchView: (orgs) ->
            new List.SearchPanel
                collection: orgs

        getLayoutView: ->
            new List.Layout

        getTableColumns: ->
            [
             { title: "Title", attrName: "title", isSortable: true, isRemovable: false, default: true },
             { title: "Description", attrName: "description", default: true },
             { title: "Size", htmlContent: '<a href="#" class="org-student-count"> <%= model.get("size") %></a>', isSortable: true, default: true },
             { htmlContent: "<div class='delete-icon'><i class='icon-remove-sign'></i></div>", className: "last-col-invisible", default: true, isRemovable: false }
            ]

        getTableOptions: (columns) ->
            columns: columns 
            region:  @layout.orgsRegion
            config:
                emptyMessage: "No organisations found :("
                itemProperties:
                    triggers:
                        "click .org-student-count"  : "org-students:clicked"
                        "click .delete-icon i"      : "org:delete:clicked"
                        "click"                     : "org:clicked"