@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->


    class Entities.Org extends Entities.Models
        relations: [
            type: Backbone.HasOne, key: 'created_by', relatedModel: Entities.AppAdmin
            # type: Backbone.HasMany, key: 'students',  relatedModel: Entities.Student, reverseRelation: { key: 'attending_org' }
        ]
        urlRoot: Routes.organisation_index_path()


    class Entities.OrgsCollection extends Entities.Collections
        model: Entities.Org
        url: Routes.organisation_index_path()

    API =
        newOrg: ->
            new Entities.Org()

        setCurrentOrg: (currentOrg) ->
            new Entities.Org currentOrg

        getOrgEntity: (id) ->
            org = Entities.Org.findOrCreate
                id: id
            org.fetch
                reset: true
            org

        getOrgEntities: ->
            orgs = new Entities.OrgsCollection
            orgs.fetch
                reset: true
            orgs

        getSearchOrgEntities: (searchTerm) ->
            orgs = new Entities.OrgsCollection
            orgs.fetch
                reset: true
                data: $.param(searchTerm)
            orgs

    App.reqres.setHandler "new:org:entity", ->
        API.newOrg()

    App.reqres.setHandler "set:current:org", (currentOrg) ->
        API.setCurrentOrg currentOrg

     App.reqres.setHandler "org:entities", ->
        API.getOrgEntities()

     App.reqres.setHandler "org:entity", (id) ->
        API.getOrgEntity id

    App.reqres.setHandler "search:orgs:entities", (searchTerm) ->
        API.getSearchOrgEntities searchTerm