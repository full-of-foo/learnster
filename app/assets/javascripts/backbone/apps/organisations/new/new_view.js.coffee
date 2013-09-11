@Learnster.module "OrgsApp.New", (New, App, Backbone, Marionette, $, _) ->

	class New.View extends App.Views.ItemView
		template: "organisations/new/templates/new_org"

		triggers:
			"click .cancel-new-org" : "form:cancel:button:clicked"


