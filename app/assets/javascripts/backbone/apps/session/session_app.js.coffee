@Learnster.module "SessionApp", (SessionApp, App, Backbone, Marionette, $, _, LearnsterCollab) ->

  class SessionApp.Router extends App.Routers.AppRouter
    appRoutes:
      "login" : "showLogin"
      "signup": "showSignUp"
      "signup/:id/confirm/:code" : "showSignUpFromRegister"


  API =
    showLogin: ->
      new SessionApp.Show.Controller()

    showSignUp: ->
      new SessionApp.Create.Controller()

    showSignUpFromRegister: (admin_id, reg_code) ->
      new SessionApp.Create.Controller
        admin_id: admin_id
        code: reg_code

    getDestroyIconView: ->
      new SessionApp.Destroy.Icon()

  App.vent.on "session:created", (currentUser = null) ->
    App.execute "reset:regions"

  App.vent.on "session:destroyed", (currentUser = null) ->
    App.execute "reset:regions"
    LearnsterCollab.getInstance().stop()

  App.reqres.setHandler "new:destroy:icon:view", ->
    API.getDestroyIconView()

  App.addInitializer ->
    new SessionApp.Router
      controller: API

, LearnsterCollab
