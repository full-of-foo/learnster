@Learnster.module "HeaderApp", (HeaderApp, App, Backbone, Marionette, $, _) ->
    @startWithParent = false

    API =
        listHeader: ->
            new HeaderApp.List.Controller
                        region: App.headerRegion


    HeaderApp.on "start", ->
        API.listHeader()