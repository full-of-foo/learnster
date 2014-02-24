@Learnster.module "LearningModulesApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Controllers.Base

    initialize: (options) ->
      @_isTeachingModules = options.isTeachingModules
      @_nestingOrgId = if options.id then options.id else false
      @_nestingOrg = if @_nestingOrgId then App.request("org:entity", @_nestingOrgId) else false

      modules = @getModules()

      @layout = @getLayoutView()

      @listenTo @layout, "show", =>
        @showSearch modules
        @showPanel modules
        @showModules modules

      @show @layout

    getModules: ->
      if not @_isTeachingModules
        modules = App.request("learning_module:entities", @_nestingOrgId)
      else
        modules = App.request("admin:learning_module:entities", @_nestingOrgId, App.currentUser.get('id'))
      modules

    showNewRegion: ->
      @layout.newRegion['_nestingOrgId'] = @_nestingOrgId
      App.execute "new:module:view", @layout.newRegion

    showPanel: (modules) ->
      if @_isTeachingModules
        panelView = @getMyPanelView modules
      else
        panelView = @getPanelView modules

      @listenTo panelView, "new:module:button:clicked", =>
          @showNewRegion()

      @layout.panelRegion.show panelView

    showSearch: (modules) ->
      searchView = @getSearchView modules

      @listenTo searchView, "search:submitted", (searchTerm) =>
        @searchModules searchTerm

      @layout.searchRegion.show searchView

    searchModules: (searchTerm) ->
      educatorId = App.currentUser.get('id')

      searchOpts =
        nestedId: @_nestingOrg?.id
        term: searchTerm
        educatorId: educatorId if @_isTeachingModules

      @showSearchModules(searchOpts)

    showModules: (modules) ->
      cols = @getTableColumns()
      options = @getTableOptions cols

      @modulesView = App.request "table:wrapper", modules, options

      @listenTo @modulesView, "childview:module:clicked", (child, args) ->
        App.vent.trigger "module:clicked", args.model

      @listenTo @modulesView, "childview:module:delete:clicked", (child, args) ->
        model = args.model
        dialogView = @getDialogView model
        @listenTo dialogView, "dialog:delete:module:clicked", =>
          dialogView.$el.modal "hide"
          model.destroy()

        @show dialogView,
          loading:
            loadingType: "spinner"
          region: App.dialogRegion

      @show @modulesView,
        loading:
          loadingType: "spinner"
        region:  @layout.learningModulesRegion

    showSearchModules: (searchOpts) ->
      modules = App.request "search:learning_module:entities", searchOpts
      @showModules(modules)

    showFetchedModules: ->
      modules = @getModules()
      @showModules(modules)

    getPanelView: (modules) ->
      new List.Panel
        collection: modules
        templateHelpers:
          nestingOrg: @_nestingOrg

    getMyPanelView: (modules) ->
      new List.MyPanel
        collection: modules
        templateHelpers:
          nestingOrg: @_nestingOrg

    getSearchView: (modules) ->
      new List.SearchPanel
        collection: modules
        templateHelpers:
          nestingOrg: @_nestingOrg

    getDialogView: (module) ->
      new List.DeleteDialog
        model: module

    getLayoutView: ->
      new List.Layout

    getTableColumns: ->
      # TODO - permission to see delete col
      [
       { title: "Title", attrName: "title", isSortable: true, isRemovable: false, default: true },
       { title: "Description", attrName: "description", default: true, isRemovable: false },
       { title: "# Supplements", htmlContent: '<%= model.get("supplement_count") %>', default: true,  isSortable: true, isRemovable: false },
       { title: "Manager", attrName: "educator.full_name", isSortable: true, isRemovable: false, default: true },
       { htmlContent: '<div class="delete-icon"><i class="icon-remove-sign"></i></div>', className: "last-col-invisible", default: true, isRemovable: false }
      ]

    getTableOptions: (columns) ->
      columns: columns
      region: @layout.learningModulesRegion
      config:
        emptyMessage: "No modules found :("
        itemProperties:
          triggers:
            "click .delete-icon i"   : "module:delete:clicked"
            "click"                  : "module:clicked"
            "click .org-link"        : "org:clicked"
