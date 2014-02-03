@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.AppAdmin extends Entities.Models
    urlRoot: Routes.api_app_admin_index_path()

  API =
    setCurrentAppAdmin: (attrs) ->
      new Entities.AppAdmin attrs

    getAppAdminEntity: (id) ->
      AppAdmin = Entities.AppAdmin.findOrCreate
                                      id: id
      AppAdmin.fetch
        reset: true
      AppAdmin

    newAppAdmin: ->
      new Entities.AppAdmin


  App.reqres.setHandler "new:appAdmin:entity", ->
    API.newAppAdmin()

  App.reqres.setHandler "init:current:appAdmin", (attrs) ->
    API.setCurrentAppAdmin attrs

  App.reqres.setHandler "appAdmin:entity", (id) ->
    API.getAppAdminEntity id
