@Learnster.module "HeaderApp.List", (List, App, Backbone, Marionette, $, _) ->

	class List.Controller extends App.Controllers.Base

		initialize: (options) ->
			links = App.request "header:entities"
			headerView = @getHeaderView(links)
			@contentView = headerView


		getHeaderView: (links) ->
			new List.Headers
				# collection:links

	App.reqres.setHandler "get:header:dock:view", ->
		new List.Controller().contentView
