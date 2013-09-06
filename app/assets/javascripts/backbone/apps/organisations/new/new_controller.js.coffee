@Learnster.module "OrgsApp.New", (New, App, Backbone, Marionette, $, _) ->

	New.Controller = 

		newOrg: ->
			newView = @getNewView()

			newView

		getNewView: ->
			new New.View()
