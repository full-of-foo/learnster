@Learnster.module "LoginApp", (LoginApp, App, Backbone, Marionette, $, _) ->

    class LoginApp.Router extends Marionette.AppRouter
        appRoutes:
            "login": "showLogin"


    API =
        showLogin: ->
            new LoginApp.Show.Controller()


    App.vent.on "session:created", (session) ->
        console.log session
        # App.navigate Routes.

    App.addInitializer ->
        new LoginApp.Router
            controller: API

