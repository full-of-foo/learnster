@Learnster.module "UsersApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->

	class Edit.Student extends App.Views.ItemView
		template: "users/edit/edit_student"
