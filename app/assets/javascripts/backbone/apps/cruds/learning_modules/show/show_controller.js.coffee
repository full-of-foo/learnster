@Learnster.module "LearningModulesApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends App.Controllers.Base

    initialize: (options) ->
      id = options.id
      module = App.request "learning_module:entity", id
      @layout = @getLayoutView module

      @listenTo @layout, "show", =>
        @showModule(module)

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
