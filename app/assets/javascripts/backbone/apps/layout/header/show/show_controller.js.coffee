@Learnster.module "HeaderApp.Show", (Show, App, Backbone, Marionette, $, _) ->

	class Show.Controller extends App.Controllers.Base

		initialize: (options) ->
			@layout = @getLayoutView()

			@listenTo @layout, "show", =>
				@showDock()
				@showLogout()

			@show @layout

		showDock: ->
			dockView =   App.request "get:header:dock:view"

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
