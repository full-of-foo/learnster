@Learnster.module "Views", (Views, App, Backbone, Marionette, $, _) ->

	class Views.ItemView extends Marionette.ItemView

		serializeData: ->
			super

		removeButtons: ->
			@['form'] = {} if !@form
			@form['buttons'] = false
