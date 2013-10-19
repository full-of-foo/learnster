@Learnster.module "StatsApp", (StatsApp, App, Backbone, Marionette, $, _) ->

	class StatsApp.Router extends Marionette.AppRouter
		appRoutes:
			"stat/:orgId/:type/:range"       : "showStat"
			"stats"    		 				 : "listStats"


	API =
		listStats: ->
			new StatsApp.List.Controller()

		showStat: (orgId, type, range) ->
			new StatsApp.Show.Controller
									orgId: orgId
									type:  type
									range: range

	App.addInitializer ->
		new StatsApp.Router
			controller: API