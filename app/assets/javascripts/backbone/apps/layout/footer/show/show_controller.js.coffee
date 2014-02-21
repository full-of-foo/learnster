@Learnster.module "FooterApp.Show", (Show, App, Backbone, Marionette, $, _) ->

    class App.Entities.AppVersion extends App.Entities.Models

    class Show.Controller extends App.Controllers.Base

        initialize: ->
          console.log App.version
          versionModel = new App.Entities.AppVersion(version: App.version)
          footerView = @getFooterView(versionModel)
          @show footerView

        getFooterView: (versionModel) ->
            new Show.Footer(model: versionModel)


