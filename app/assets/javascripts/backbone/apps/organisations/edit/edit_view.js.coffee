@Learnster.module "OrgsApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->

	class Edit.Layout extends App.Views.Layout
		template: "organisations/edit/templates/edit_layout"
		regions: 
			titleRegion:  "#title-region"
			formRegion:   "#form-region"


	class Edit.Title extends App.Views.ItemView
  		template: "organisations/edit/templates/edit_title"
  		modelEvents:
            "updated": "render"


	class Edit.Org extends App.Views.ItemView
		template: "organisations/edit/templates/edit_org" 
		modelEvents:
            "sync:after": "render"
        triggers:
            "click #org-students-link"  : "org-students:clicked"
            "click #org-admins-link"    : "org-admins:clicked"

        onShow: ->
            $("#org-created-by-link").on "click", (e) ->
                e.preventDefault()

 