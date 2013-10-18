@Learnster.module "SessionApp.Destroy", (Destroy, App, Backbone, Marionette, $, _) ->


	class Destroy.Icon extends App.Views.ItemView
		template: "session/destroy/templates/destroy_icon"
		triggers:
			"click #destroy-session-icon"   : "session:destroy:clicked"



