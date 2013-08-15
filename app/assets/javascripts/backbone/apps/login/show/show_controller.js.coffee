@Learnster.module "LoginApp.Show", (Show, App, Backbone, Marionette, $, _) ->

    Show.Controller =

        showLogin: ->
            loginView = @getLoginView()
            App.mainRegion.show loginView

        getLoginView: ->
            new Show.Login
