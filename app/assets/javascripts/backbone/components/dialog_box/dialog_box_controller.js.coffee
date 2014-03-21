@Learnster.module "Components.DialogBox", (DialogBox, App, Backbone, Marionette, $, _) ->

  class DialogBox.Controller extends App.Controllers.Base
    initialize: (options = {}) ->
      dialogOpts  = options.options
      dialogModel = App.request "dialog:box:entity", dialogOpts
      dialogView = @getDialogView dialogModel

      @show dialogView,
        region: App.dialogRegion

    getDialogView: (model) ->
      new DialogBox.Dialog
        model: model

  App.reqres.setHandler "show:dialog:box", (options) ->
    new DialogBox.Controller
        options: options

