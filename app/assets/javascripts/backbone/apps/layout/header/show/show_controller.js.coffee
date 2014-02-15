@Learnster.module "HeaderApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends App.Controllers.Base

    initialize: (options) ->
      @layout = @getLayoutView()
      user = App.request "get:current:user"

      @listenTo @layout, "show", =>
        @showDock()
        @showLogout() if Object(user) not instanceof Boolean

      @show @layout

    showDock: ->
      dockView =   App.request "get:header:dock:view"

      @listenTo dockView, "home:dockItem:clicked", ->
        App.commands.execute "redirect:home"

      @listenTo dockView, "stats:dockItem:clicked", ->
        App.navigate "/statistics"

      @listenTo dockView, "notifications:dockItem:clicked", ->
        App.vent.trigger "notifications:link:clicked"

      @listenTo dockView, "about:dockItem:clicked", ->
        App.navigate "/about"

      @listenTo dockView, "testimonials:dockItem:clicked", ->
        App.navigate "/testimonials"

      @listenTo dockView, "join:dockItem:clicked", ->
        App.navigate "/signup"

      @show dockView,
          region: @layout.dockRegion

    showLogout: ->
      logoutView = App.request "new:destroy:icon:view"

      @listenTo logoutView, "session:destroy:clicked", ->
        App.request "destroy:session"

      @show logoutView,
          region:  @layout.logoutRegion

    getLayoutView:  ->
      new Show.Layout()
