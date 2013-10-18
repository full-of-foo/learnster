@Learnster.module "HeaderApp", (HeaderApp, App, Backbone, Marionette, $, _) ->
	@startWithParent = false

	API =
		showHeader: ->
			new HeaderApp.Show.Controller
						region: App.headerRegion


	App.commands.setHandler "show:header", ->
		API.showHeader()

	HeaderApp.on "start", ->
		API.showHeader()