@Learnster.module "LoginApp", (LoginApp, App, Backbone, Marionette, $, _) ->

    class LoginApp.Router extends Marionette.AppRouter
        appRoutes:
            "login": "showLogin"


    API =
        showLogin: ->
            new LoginApp.Show.Controller()

    App.addInitializer ->
        new LoginApp.Router
            controller: API
