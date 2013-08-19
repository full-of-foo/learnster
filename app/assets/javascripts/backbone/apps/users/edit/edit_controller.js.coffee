@Learnster.module "UsersApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->

	Edit.Controller =

		edit: (student) ->
			editView = @getEditView student
			
			App.mainRegion.show editView


		getEditView: (student) ->
			new Edit.Student
				model:student
