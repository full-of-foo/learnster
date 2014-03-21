@Learnster.module "Components.DialogBox", (DialogBox, App, Backbone, Marionette, $, _) ->

  class DialogBox.Controller extends App.Controllers.Base
    initialize: (options = {}) ->
      dialogOpts  = options.options
      dialogModel = App.request "dialog:box:entity", dialogOpts
      dialogView = @getDialogView dialogModel

      if dialogModel.get('primary').callback
        @listenTo dialogView, "dialog:primary:clicked", ->
          dialogModel.get('primary').callback()

      if dialogModel.get('secondary').callback
        @listenTo dialogView, "dialog:secondary:clicked", ->
          dialogModel.get('secondary').callback()

      @show dialogView,
        region: App.dialogRegion

    getDialogView: (model) ->
      new DialogBox.Dialog
        model: model

  App.reqres.setHandler "show:dialog:box", (options) ->
    new DialogBox.Controller
        options: options

