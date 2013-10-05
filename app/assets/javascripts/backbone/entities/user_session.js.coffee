@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

    class Entities.UserSession extends Entities.Models
        url: Routes.api_user_session_path()

        defaults:
            "email"    : ""
            "password" : ""


    API =
        setSession: (attrs) ->
            new Entities.UserSession attrs
 
        newSession: ->
            new Entities.UserSession()


    App.reqres.setHandler "new:user:session", ->
        API.newSession()

    App.reqres.setHandler "init:session", (attrs) ->
        API.setSession attrs
