@Learnster.module "StudentsApp.New", (New, App, Backbone, Marionette, $, _) ->

	class New.Layout extends App.Views.Layout
		template: "students/new/templates/new_layout"
		regions: 
			formRegion:   "#form-region"


	class New.View extends App.Views.Layout
		template: "students/new/templates/new_student"
		regions:
			orgSelectRegion: "#org-select-region"
			
		triggers:
			"click .cancel-new-student" : "form:cancel"

		form:
			buttons: 
				primary: 	  "Add Student"
				primaryClass: "btn btn-primary"