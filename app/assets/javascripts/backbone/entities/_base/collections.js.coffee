@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

	class Entities.Collections extends Backbone.Collection

		initialize: ->
			@on "all", (e) -> console.log e if App.enviornment is "development"
			@on "unpermitted:entity", (entity) ->
					App.execute "redirect:home"

		fetch: (options = {}) ->
			# options.reset = true
			super options
