@Learnster.module "UsersApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->

	Edit.Controller =

		edit: (id, student) ->
			student or= App.request "student:entity", id
			editView = @getEditView student
			console.log editView
			
			App.mainRegion.show editView


		getEditView: (student) ->
			new Edit.Student
				model:student
