@Learnster.module "OrgAdminsApp.New", (New, App, Backbone, Marionette, $, _) ->

	class New.Layout extends App.Views.Layout
		template: "org_admins/new/templates/new_layout"
		regions: 
			formRegion:   "#form-region"


	class New.View extends App.Views.Layout
		template: "org_admins/new/templates/new_org_admin"
		regions:
			orgSelectRegion: "#org-select-region"
			
		triggers:
			"click .cancel-new-org-admin" : "form:cancel"

		form:
			buttons: 
				primary: 	  "Add Admin"
				primaryClass: "btn btn-primary"