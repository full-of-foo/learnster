@Learnster.module "OrgsApp", (OrgsApp, App, Backbone, Marionette, $, _) ->

    class OrgsApp.Router extends Marionette.AppRouter
            appRoutes:
                "organisations": "listOrgs"


        API =
            listOrgs: ->
                OrgsApp.List.Controller.listOrgs()

        App.addInitializer ->
            new OrgsApp.Router
                controller: API