@Learnster = do (Backbone, Marionette) ->

    App = new Marionette.Application()

    App.on "initialize:before", (options) ->
        if options.currentUser.id?
            @currentUser = App.request("set:current:user", options.currentUser)
        else
            @currentUser = null

    App.reqres.setHandler "get:current:user", ->
        App.currentUser


    App.addRegions
        headerRegion: "#header-region"
        mainRegion: "#main-region"
        footerRegion: "#footer-region"

    App.addInitializer ->
        App.module("HeaderApp").start()
        App.module("FooterApp").start()


    App.on "initialize:after", ->
            @startHistory()
            App.rootRoute = if App.currentUser? then "/users" else "/login"
            @navigate(@rootRoute, trigger: true) if @getCurrentRoute() is ""

    App