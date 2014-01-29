@Learnster.module "SessionApp", (SessionApp, App, Backbone, Marionette, $, _) ->

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

  App.vent.on "session:created session:destroyed", (currentUser = null) ->
    App.execute "reset:regions"

  App.reqres.setHandler "new:destroy:icon:view", ->
    API.getDestroyIconView()

  App.addInitializer ->
    new SessionApp.Router
      controller: API
