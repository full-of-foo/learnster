@Learnster.module "UsersApp.New", (New, App, Backbone, Marionette, $, _) ->

	class New.Layout extends App.Views.Layout
		template: "users/new/templates/new_layout"
		regions: 
			formRegion:   "#form-region"


	class New.View extends App.Views.Layout
		template: "users/new/templates/new_student"
		regions:
			orgSelectRegion: "#org-select-region"
			
		triggers:
			"click .cancel-new-student" : "form:cancel"

		form:
			buttons: 
				primary: 	  "Add User"
				primaryClass: "btn btn-primary"