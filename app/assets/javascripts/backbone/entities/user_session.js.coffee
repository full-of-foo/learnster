@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.UserSessionDestroy extends Entities.Models
    url: Routes.api_logout_path()

  class Entities.UserSession extends Entities.Models
    url: Routes.api_login_path()
    defaults:
      "email"    : ""
      "password" : ""

    save: (data, options = {}) ->
      _.extend options,
        is_sign_in: true

      super data, options


  API =
    setSession: (attrs) ->
      new Entities.UserSession attrs

    newSession: ->
      new Entities.UserSession
              id: null

    newSessionDestroy: ->
      new Entities.UserSessionDestroy()


  App.reqres.setHandler "new:user:session", ->
    API.newSession()

  App.reqres.setHandler "new:user:session:destroy", ->
    API.newSessionDestroy()

  App.reqres.setHandler "init:session", (attrs) ->
    API.setSession attrs
