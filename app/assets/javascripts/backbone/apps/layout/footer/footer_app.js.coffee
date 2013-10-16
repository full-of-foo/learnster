@Learnster.module "FooterApp", (FooterApp, App, Backbone, Marionette, $, _) ->
	@startWithParent = false

	API =
		showFooter: ->
			new FooterApp.Show.Controller
						region: App.footerRegion

	FooterApp.on "start", ->
		API.showFooter()
