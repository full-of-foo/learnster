@Learnster.module "UsersApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->

	class Edit.Layout extends App.Views.Layout
		template: "users/edit/templates/edit_layout"

		regions: 
			formRegion: "#form-region"


	class Edit.Student extends App.Views.ItemView
		template: "users/edit/templates/edit_student" 
		modelEvents:
            "change": "render"

		initialize: ->
			console.log @model

		# form:
		# 	footer: false

