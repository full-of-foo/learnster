@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->


    class Entities.Org extends Entities.Models

    class Entities.OrgsCollection extends Entities.Collections
        model: Entities.Org
        url: Routes.organisation_index_path()

    API =
        setCurrentOrg: (currentOrg) ->
            new Entities.Org currentOrg

        getOrgEntities: (cb) ->
            orgs = new Entities.OrgsCollection
            orgs.fetch
                reset: true,
                success: ->
                    cb orgs

    App.reqres.setHandler "set:current:org", (currentOrg) ->
        API.setCurrentOrg currentOrg

     App.reqres.setHandler "org:entities", (cb) ->
        API.getOrgEntities cb