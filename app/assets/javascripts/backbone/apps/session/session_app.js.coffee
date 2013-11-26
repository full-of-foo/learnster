@Learnster.module "SessionApp", (SessionApp, App, Backbone, Marionette, $, _) ->

	class SessionApp.Router extends Marionette.AppRouter
		appRoutes:
			"login": "showLogin"


	API =
		showLogin: ->
			new SessionApp.Show.Controller()

		getDestroyIconView: ->
			new SessionApp.Destroy.Icon()


	App.vent.on "session:created session:destroyed", (currentUser = null) ->
		App.execute "reset:regions"

	App.reqres.setHandler "new:destroy:icon:view", ->
    	API.getDestroyIconView()

	App.addInitializer ->
		new SessionApp.Router
			controller: API

