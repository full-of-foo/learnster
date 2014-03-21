@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Dialog extends Entities.Models

  API =
    getDialogEntity: (options) ->
      new Entities.Dialog(@getDefaultOptions(options))

    getDefaultOptions: (options) ->
      _.defaults options,
        contentText: ""
        primary:
          cssClass: "btn btn-success"
          text:     "Okay"
        secondary:
          cssClass:   "btn"
          text:       "Cancel"
          hasDismiss: true
        headerText: "Learnster"
        hasDismiss: true

  App.reqres.setHandler "dialog:box:entity", (options) ->
    API.getDialogEntity(options)
