@Learnster.module "OrgAdminsApp.Import", (Import, App, Backbone, Marionette, $, _) ->

    class Import.Controller extends App.Controllers.Base

      initialize: (options = {}) ->
        organisation = options.model
        dialogView = @getDialogView organisation

        @show dialogView,
          loading:
            loadingType: "spinner"

      getDialogView: (organisation) ->
        new Import.Dialog
          model: organisation

