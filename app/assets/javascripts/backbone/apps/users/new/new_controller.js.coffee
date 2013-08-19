@Learnster.module "UsersApp.New", (New, App, Backbone, Marionette, $, _) ->

	New.Controller =

		newStudent: ->
			newView = @getNewView()

			newView

		getNewView: ->
			new New.View()