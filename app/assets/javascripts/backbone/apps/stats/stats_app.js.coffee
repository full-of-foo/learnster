@Learnster.module "StatsApp", (StatsApp, App, Backbone, Marionette, $, _) ->

	class StatsApp.Router extends Marionette.AppRouter
		appRoutes:
			"stat/:title"    : "showStat"
			"stats"    		 : "listStats"


	API =
		listStats: ->
			new StatsApp.List.Controller()

		showStat: (title) ->
			new StatsApp.Show.Controller
								title: title

	App.addInitializer ->
		new StatsApp.Router
			controller: API