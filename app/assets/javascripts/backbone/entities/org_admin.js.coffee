@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.OrgAdmin extends Entities.Models
    urlRoot: Routes.api_org_admin_index_path()

  class Entities.OrgAdminCollection extends Entities.Collections
    model: Entities.OrgAdmin

    initialize: (options = {}) =>
      @url = if not options.url then Routes.api_org_admin_index_path() else options.url
      super


  API =
    setCurrentOrgAdmin: (attrs) ->
      new Entities.OrgAdmin(attrs)

    getOrgAdminEntities: ->
      org_admins = new Entities.OrgAdminCollection()
      org_admins.fetch
        reset: true
      org_admins

    getOrgAdminOrgEntities: (orgId) ->
      org_admins = new Entities.OrgAdminCollection
                          url: Routes.api_organisation_admin_index_path(orgId)
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

    getSearchOrgAdminEntities: (searchOpts) ->
      { term, nestedId } = searchOpts
      if nestedId
        org_admins = new Entities.OrgAdminCollection
                                    url: Routes.api_organisation_admin_index_path(nestedId)
      else
        org_admins = new Entities.OrgAdminCollection()
      org_admins.fetch
        reset: true
        data: $.param(term)
      org_admins.put('search', term['search'])
      org_admins


  App.reqres.setHandler "new:org_admin:entity", ->
    API.newOrgAdmin()

  App.reqres.setHandler "new:new_org_admin:entity", ->
    admin = API.newOrgAdmin()
    admin['urlRoot'] = Routes.api_sign_up_account_manager_path()
    admin

  App.reqres.setHandler "init:current:orgAdmin", (attrs) ->
    API.setCurrentOrgAdmin(attrs)

  App.reqres.setHandler "org:org_admin:entities", (orgId) ->
    API.getOrgAdminOrgEntities(orgId)

  App.reqres.setHandler "org_admin:entities", ->
    API.getOrgAdminEntities()

  App.reqres.setHandler "org_admin:entity", (id) ->
    API.getOrgAdminEntity(id)

  App.reqres.setHandler "search:org_admins:entities", (searchTerm) ->
    API.getSearchOrgAdminEntities(searchTerm)
