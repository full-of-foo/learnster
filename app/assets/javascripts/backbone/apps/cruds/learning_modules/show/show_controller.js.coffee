@Learnster.module "LearningModulesApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends App.Controllers.Base

    initialize: (options) ->
      id = options.id
      module = App.request "learning_module:entity", id
      @layout = @getLayoutView module

      @listenTo @layout, "show", =>
        @showModule(module)
        @showPanel(module)
        @showSupplements(module)

      @show @layout

    showModule: (module) ->
      moduleView = @getShowView(module)

      @listenTo moduleView, "edit:module:button:clicked", (view) ->
        App.vent.trigger "edit:module:clicked", view

      @listenTo moduleView, "delete:module:button:clicked", (view) ->
        model = view.model
        @showDeleteDialog(model)

      @show moduleView,
        loading:
          loadingType: "spinner"
        region: @layout.moduleRegion

    showPanel: (module) ->
      panelView = @getPanelView(module)

      @show panelView,
        loading:
          loadingType: "spinner"
        region: @layout.panelRegion

    showSupplements: (module) ->
      @moduleId = module.get('id')
      supplements = App.request("module:supplement:entities", @moduleId)
      supplementsView = @getSupplementsView(supplements)

      @listenTo supplementsView, "childview:supplement:clicked", (child, args) ->
        App.vent.trigger "supplement:clicked", args.model

      @show supplementsView,
        loading:
          loadingType: "spinner"
        region: @layout.supplementsRegion


    showDeleteDialog: (module) ->
      dialogView = @getDialogView module

      @listenTo dialogView, "dialog:delete:module:clicked", =>
        orgId = module.get('organisation_id')
        dialogView.$el.modal "hide"
        module.destroy()
        module.on "destroy", -> App.navigate "/organisation/#{orgId}/modules"

      @show dialogView,
        loading:
          loadingType: "spinner"
        region: App.dialogRegion

    getLayoutView: (module) ->
      new Show.Layout
        model: module

    getShowView: (module) ->
      new Show.Module
        model: module

    getDialogView: (module) ->
      new Show.DeleteDialog
        model: module

    getPanelView: (module) ->
      new Show.Panel
        model: module

    getSupplementsView: (supplements) ->
      cols = @getTableColumns()
      options = @getTableOptions cols
      App.request "table:wrapper", supplements, options


    getTableColumns: ->
      [
       { title: "Title", attrName: "title", isSortable: true, default: true, isRemovable: false },
       { title: "Description", attrName: "description", default: true }
      ]

    getTableOptions: (columns) ->
      columns: columns
      region: @layout.supplementsRegion
      config:
        emptyMessage: "No supplements added :("
        itemProperties:
          triggers:
              "click .delete-icon i"   : "supplement:delete:clicked"
              "click"                  : "supplement:clicked"
