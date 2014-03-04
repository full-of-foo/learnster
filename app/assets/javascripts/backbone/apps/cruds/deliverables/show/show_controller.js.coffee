@Learnster.module "DeliverablesApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends App.Controllers.Base

    initialize: (options) ->
      deliverableId = if options.id instanceof App.Entities.Deliverable then options.
        id.get('id') else options.id
      @deliverable = App.request "deliverable:entity", deliverableId

      @layout = @getLayoutView @deliverable

      @listenTo @layout, "show", =>
        @showDeliverable(@deliverable)

      @show @layout

    showDeliverable: (deliverable) ->
      deliverableView = @getShowView(deliverable)

      @listenTo deliverableView, "delete:deliverable:button:clicked", (view) ->
        model = view.model
        @showDeleteDeliverableDialog(model)

      @listenTo deliverableView, "edit:deliverable:button:clicked", (view) ->
        model = view.model
        App.navigate "/deliverable/#{model.get('id')}/edit"

      @listenTo deliverableView, "cancel:show:deliverable:button:clicked", (view) ->
        deliverable = view.model
        moduleId = deliverable.get('learning_module').id
        App.navigate "/module/#{moduleId}/show"

      @show deliverableView,
        loading:
          loadingType: "spinner"
        region: @layout.deliverableRegion

    showDeleteDeliverableDialog: (deliverable) ->
      dialogView = @getDeliverableDialogView deliverable
      @listenTo dialogView, "dialog:delete:deliverable:clicked", =>
        dialogView.$el.modal "hide"
        moduleId     = deliverable.get('module_supplement').learning_module.id
        supplementId =  deliverable.get('module_supplement').id
        deliverable.destroy()
        deliverable.on "destroy", => App.navigate "/module/#{moduleId}/supplement/#{supplementId}/show"

      @show dialogView,
        loading:
          loadingType: "spinner"
        region: App.dialogRegion

    getLayoutView: (deliverable) ->
      new Show.Layout
        model: deliverable

    getShowView: (deliverable) ->
      new Show.Deliverable
        model: deliverable

    getDeliverableDialogView: (deliverable) ->
      new Show.DeleteDeliverableDialog
        model: deliverable
