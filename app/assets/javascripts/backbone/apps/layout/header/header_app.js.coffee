@Learnster.module "HeaderApp", (HeaderApp, App, Backbone, Marionette, $, _) ->
	@startWithParent = false

	API =
		listHeader: ->
			new HeaderApp.List.Controller
						region: App.headerRegion


	App.commands.setHandler "list:headers", ->
		API.listHeader()

	HeaderApp.on "start", ->
		API.listHeader()