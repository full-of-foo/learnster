@Learnster.module "HeaderApp.Show", (Show, App, Backbone, Marionette, $, _, LearnsterCollab) ->

  class Show.Controller extends App.Controllers.Base

    initialize: (options) ->
      @layout = @getLayoutView()
      user = App.request "get:current:user"

      @listenTo @layout, "show", =>
        @showDock()
        @showLogout()      if Object(user) not instanceof Boolean
        @showSubLogo(user) if Object(user) not instanceof Boolean

      @show @layout

    showDock: ->
      dockView =   App.request "get:header:dock:view"

      @listenTo dockView, "home:dockItem:clicked", ->
        App.commands.execute "redirect:home"

      @listenTo dockView, "stats:dockItem:clicked", ->
        App.navigate "/statistics"

      @listenTo dockView, "collaborate:dockItem:clicked", ->
        if $('#collab-success').length is 0 and LearnsterCollab.getInstance().isInitializing() is false
          LearnsterCollab.getInstance().start()

      @listenTo dockView, "notifications:dockItem:clicked", ->
        App.vent.trigger "notifications:link:clicked"

      @listenTo dockView, "settings:dockItem:clicked", ->
        user = App.request "get:current:user"
        orgId = if user.get('type') is "OrgAdmin" then user.get('admin_for').id else user.get('attending_org').id
        App.navigate "/organisation/#{orgId}/my_settings"

      @listenTo dockView, "about:dockItem:clicked", ->
        App.navigate "/about"

      @listenTo dockView, "testimonials:dockItem:clicked", ->
        App.navigate "/testimonials"

      @listenTo dockView, "join:dockItem:clicked", ->
        App.navigate "/signup"

      @show dockView,
          region: @layout.dockRegion

    showSubLogo: (user) ->
      logoView = @getSubLogoView(user)
      @show logoView,
          region: @layout.subLogoRegion

    showLogout: ->
      logoutView = App.request "new:destroy:icon:view"

      @listenTo logoutView, "session:destroy:clicked", ->
        App.request "destroy:session"

      @show logoutView,
          region:  @layout.logoutRegion

    getLayoutView:  ->
      new Show.Layout()

    getSubLogoView: (user) ->
      new Show.SubLogo
        model: user

, LearnsterCollab
