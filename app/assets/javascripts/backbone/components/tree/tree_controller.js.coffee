@Learnster.module "Components.Tree", (Tree, App, Backbone, Marionette, $, _) ->

	App.reqres.setHandler "tree:wrapper", (collection) ->
		throw new Error "No sidebar collection supplied" unless collection
		new Tree.SideBar
				collection: collection

