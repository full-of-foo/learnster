@Learnster.module "UsersApp.New", (New, App, Backbone, Marionette, $, _) ->

	class New.View extends App.Views.ItemView
		template: "users/new/templates/new_student"

		triggers:
			"click .cancel-new-student" : "form:cancel:button:clicked"