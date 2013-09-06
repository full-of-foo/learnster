@Learnster.module "OrgsApp", (OrgsApp, App, Backbone, Marionette, $, _) ->


    class OrgsApp.Router extends Marionette.AppRouter
        appRoutes:
                "organisations": "listOrgs"


    API =  
        newOrg: ->
            OrgsApp.New.Controller.newOrg()

        listOrgs: ->
            OrgsApp.List.Controller.listOrgs()



    App.reqres.setHandler "new:org:view", ->
                API.newOrg()


    App.addInitializer ->
        new OrgsApp.Router 
                controller: API