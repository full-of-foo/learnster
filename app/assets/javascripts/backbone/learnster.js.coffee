@Learnster = do (Backbone, Marionette) ->

    App = new Marionette.Application()
    

    App.on "initialize:before", (options) ->
        App.environment = options.environment

    App.reqres.setHandler "get:current:user", ->
        App.currentUser = null #nyi

    App.reqres.setHandler "default:region", ->
        App.mainRegion

    App.addRegions
        headerRegion: "#header-region"
        mainRegion: "#main-region"
        footerRegion: "#footer-region"

    App.addInitializer ->
        App.module("HeaderApp").start()
        App.module("FooterApp").start()


    App.commands.setHandler "unregister:instance", (instance, id) ->
        App.unregister instance, id if App.environment is "development"

    App.commands.setHandler "register:instance", (instance, id) ->
        App.register instance, id if App.environment is "development"


    App.on "initialize:after", ->
            @startHistory()
            App.rootRoute = if App.currentUser? then "/users" else "/login"
            @navigate(@rootRoute, trigger: true) if @getCurrentRoute() is ""

    App