@Learnster.module "StatsApp", (StatsApp, App, Backbone, Marionette, $, _) ->

	class StatsApp.Router extends Marionette.AppRouter
		appRoutes:
			"stat/:orgId/:title/:range"       : "showStat"
			"stats"    		 				 : "listStats"


	API =
		listStats: ->
			new StatsApp.List.Controller()

		showStat: (orgId, title, range) ->
			new StatsApp.Show.Controller
									orgId: orgId
									title:  title
									range: range

	App.addInitializer ->
		new StatsApp.Router
			controller: API