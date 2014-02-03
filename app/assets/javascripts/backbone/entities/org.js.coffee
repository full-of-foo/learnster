@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Org extends Entities.Models
    urlRoot: Routes.api_organisation_index_path()

  class Entities.OrgsCollection extends Entities.Collections
    model: Entities.Org
    url: Routes.api_organisation_index_path()

  API =
    newOrg: ->
      new Entities.Org()

    newOrgs: ->
      new Entities.OrgsCollection()

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
      orgs.put('search', searchTerm['search'])
      orgs

  App.reqres.setHandler "new:org:entity", ->
    API.newOrg()

  App.reqres.setHandler "new:signup:org:entity", (id, code) ->
    org = API.newOrg()
    org['urlRoot'] = Routes.api_sign_up_organisation_path(id, code)
    org

  App.reqres.setHandler "new:org:entities", ->
    API.newOrgs()

  App.reqres.setHandler "set:current:org", (currentOrg) ->
    API.setCurrentOrg currentOrg

  App.reqres.setHandler "org:entities", ->
    API.getOrgEntities()

  App.reqres.setHandler "org:entity", (id) ->
    API.getOrgEntity id

  App.reqres.setHandler "search:orgs:entities", (searchTerm) ->
    API.getSearchOrgEntities searchTerm
