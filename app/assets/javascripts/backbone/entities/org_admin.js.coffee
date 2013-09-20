@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->


    class Entities.OrgAdmin extends Entities.Models
        urlRoot: Routes.org_admin_index_path()
        
        initialize: ->
            @on "all", (e) -> console.log e


    class Entities.OrgAdminCollection extends Entities.Collections
        model: Entities.OrgAdmin
        url: Routes.org_admin_index_path()


    API =
        setCurrentOrgAdmin: (attrs) ->
            new Entities.OrgAdmin attrs

        getOrgAdminEntities: ->
            org_admins = new Entities.OrgAdminCollection
            org_admins.fetch
                reset: true
            org_admins

        getOrgAdminEntity: (id) ->
            org_admin = Entities.OrgAdmin.findOrCreate
                id: id
            org_admin.fetch
                reset: true
            org_admin

        newOrgAdmin: ->
            new Entities.OrgAdmin

        getSearchOrgAdminEntities: (searchTerm) ->
            org_admins = new Entities.OrgAdminCollection
            org_admins.fetch
                reset: true
                data: $.param(searchTerm)
            org_admins

    App.reqres.setHandler "new:org_admin:entity", ->
        API.newOrgAdmin()

    App.reqres.setHandler "init:current:orgAdmin", (attrs) ->
        API.setCurrentOrgAdmin attrs

    App.reqres.setHandler "set:current:org_admin", (currentOrgAdmin) ->
        API.setCurrentOrgAdmin currentOrgAdmin

    App.reqres.setHandler "org_admin:entities", ->
        API.getOrgAdminEntities() 

    App.reqres.setHandler "org_admin:entity", (id) ->
        API.getOrgAdminEntity id

    App.reqres.setHandler "search:org_admins:entities", (searchTerm) ->
        API.getSearchOrgAdminEntities searchTerm