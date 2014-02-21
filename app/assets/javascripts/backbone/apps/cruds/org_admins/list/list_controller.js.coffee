@Learnster.module "OrgAdminsApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Controllers.Base

    initialize: (options) ->
      @_isOwnedAdmins = options.isOwnedAdmins
      @_nestingOrgId = if options.id then options.id else false
      @_nestingOrg = if @_nestingOrgId then App.request("org:entity", @_nestingOrgId) else false

      org_admins = @getAdmins()

      @layout = @getLayoutView()

      @listenTo @layout, "show", =>
        @showSearch org_admins
        @showPanel org_admins
        @showOrgAdmins org_admins

      @show @layout

    getAdmins: ->
      if not @_isOwnedAdmins
        org_admins = if not @_nestingOrg then App.request("org_admin:entities") else App.request("org:org_admin:entities", @_nestingOrgId)
      else
        org_admins = App.request("admin:org_admin:entities", @_nestingOrgId, App.currentUser.get('id'))
      org_admins

    showNewRegion: ->
      @layout.newRegion['_nestingOrg'] = @_nestingOrg
      App.execute "new:org_admin:view", @layout.newRegion

    showPanel: (org_admins) ->
      if @_isOwnedAdmins
        panelView = @getMyPanelView org_admins
      else
        panelView = @getPanelView org_admins

      @listenTo panelView, "new:org_admin:button:clicked", =>
          @showNewRegion()

      if @_nestingOrg
        @listenTo panelView, "import:dropdown:clicked", =>
          App.vent.trigger("open:admin:import:dialog", @_nestingOrg)
          App.vent.on "admin:import:success", (dialogView) =>
            @showFetchedAdmins()

      @listenTo panelView, "settings:button:clicked", =>
          @showSettings()

      @layout.panelRegion.show panelView

    showSettings: ->
      listCols = @getTableColumns()
      @colCollection = @colCollection || App.request "table:column:entities", listCols, false
      settingsView = App.request "settings:view", @colCollection

      @listenTo settingsView, "childview:setting:col:clicked", (child, args) =>
        column = args.model
        @orgAdminsView.toggleColumn(child, column)

      @show settingsView,
        loading:
          loadingType: "spinner"
        region:  @layout.listSettingsRegion

    showSearch: (org_admins) ->
      searchView = @getSearchView org_admins

      @listenTo searchView, "search:submitted", (searchTerm) =>
        @searchOrgAdmins searchTerm

      @layout.searchRegion.show searchView

    searchOrgAdmins: (searchTerm) ->
      owningId = App.currentUser.get('id')

      searchOpts =
        nestedId: @_nestingOrg?.id
        term: searchTerm
        owningId: owningId if @_isOwnedAdmins

      @showSearchOrgAdmins(searchOpts)

    showOrgAdmins: (org_admins) ->
      cols = @getTableColumns()
      options = @getTableOptions cols

      @orgAdminsView = App.request "table:wrapper", org_admins, options

      @listenTo @orgAdminsView, "childview:org_admin:clicked", (child, args) ->
        App.vent.trigger "org_admin:clicked", args.model

      @listenTo @orgAdminsView, "childview:org:clicked", (child, args) ->
        App.vent.trigger "org:clicked", args.model.get('admin_for').id

      @listenTo @orgAdminsView, "childview:org_admin:delete:clicked", (child, args) ->
        model = args.model
        dialogView = @getDialogView model

        @listenTo dialogView, "dialog:delete:admin:clicked", =>
          dialogView.$el.modal "hide"
          model.destroy()
          model.on "destroy", ( =>
            org_admins = @getAdmins()
            @showOrgAdmins(org_admins))

        @show dialogView,
          loading:
            loadingType: "spinner"
          region: App.dialogRegion

      @show @orgAdminsView,
        loading:
          loadingType: "spinner"
        region:  @layout.orgAdminsRegion

    showSearchOrgAdmins: (searchOpts) ->
      org_admins = App.request "search:org_admins:entities", searchOpts
      @colCollection = null
      @showSettings() if not @layout.listSettingsRegion.currentView?.isClosed and @layout.listSettingsRegion.currentView
      @showOrgAdmins(org_admins)

    showFetchedAdmins: ->
      admins = @getAdmins()
      @colCollection = null
      @showSettings() if not @layout.listSettingsRegion?.currentView?.isClosed and @layout.listSettingsRegion?.currentView
      @showOrgAdmins(admins)

    getMyPanelView: (org_admins) ->
      new List.MyPanel
        collection: org_admins
        templateHelpers:
          nestingOrg: @_nestingOrg

    getPanelView: (org_admins) ->
      new List.Panel
        collection: org_admins
        templateHelpers:
          nestingOrg: @_nestingOrg

    getSearchView: (org_admins) ->
      new List.SearchPanel
        collection: org_admins
        templateHelpers:
          nestingOrg: @_nestingOrg

    getDialogView: (org_admin) ->
      new List.DeleteDialog
        model: org_admin

    getLayoutView: ->
      new List.Layout

    getTableColumns: ->
      cols = [
       { title: "Name", htmlContent: '<% if ( model.get("is_active") )
        { %><i class="icon-list-online-status" title="Online"></i>
        <% } else { %><i class="icon-list-offline-status" title="Offline"></i>
        <% } %><%= model.get("full_name") %>', isSortable: true, default: true, isRemovable: false }
       { title: "Email", attrName: "email", isSortable: true, default: true },
       { title: "Last Online", attrName: "last_login_formatted", default: true},
       { title: "Created On", attrName: "created_at_formatted",  isSortable: true },
       { title: "Last Updated", attrName: "updated_at_formatted"},
       { htmlContent: '<% if ( model.get("created_by") && model.get("created_by").id === currentUser.get("id")
        || currentUser.get("type") ===  "AppAdmin") { %>
        <div class="delete-icon"><i class="icon-remove-sign"></i></div>
        <% } %>', className: "last-col-invisible", default: true, isRemoveable: false}
      ]
      organisationCol = { title: "Organisation", htmlContent: '<a href="#" class="org-link">
        <% if ( model.get("admin_for") ) { %><%= model.get("admin_for").title %><% }
        %></a>', className: "wrap-text", isSortable: true, default: true }

      user = App.request "get:current:user"
      cols.insertAt(3, organisationCol) if user instanceof Learnster.Entities.AppAdmin
      cols

    getTableOptions: (columns) ->
      columns: columns
      region: @layout.orgAdminsRegion
      config:
        emptyMessage: "No admins found :("
        itemProperties:
          triggers:
            "click .delete-icon i"   : "org_admin:delete:clicked"
            "click"                  : "org_admin:clicked"
            "click .org-link"        : "org:clicked"
