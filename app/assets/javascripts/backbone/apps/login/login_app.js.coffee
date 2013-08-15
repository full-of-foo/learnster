@Learnster.module "LoginApp", (LoginApp, App, Backbone, Marionette, $, _) ->

    class LoginApp.Router extends Marionette.AppRouter
        appRoutes:
            "login": "showLogin"


    API =
        showLogin: ->
            LoginApp.Show.Controller.showLogin()

    App.addInitializer ->
        new LoginApp.Router
            controller: API
