@Learnster.module "UsersApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->

	class Edit.Layout extends App.Views.Layout
		template: "users/edit/templates/edit_layout"
		regions: 
			titleRegion:  "#title-region"
			formRegion:   "#form-region"


	class Edit.Title extends App.Views.ItemView
  		template: "users/edit/templates/edit_title"
  		modelEvents:
            "updated": "render"


	class Edit.Student extends App.Views.ItemView
		template: "users/edit/templates/edit_student" 
		modelEvents:
            "sync:after": "render"

 