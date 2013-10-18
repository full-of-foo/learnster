@Learnster.module "SessionApp.Destroy", (Destroy, App, Backbone, Marionette, $, _) ->

	class Destroy.Controller extends App.Controllers.Base

		initialize: ->
			session = App.request "new:user:session:destroy"
			@listenTo session, "sync:stop", (session, options) ->
				App.vent.trigger "session:destroyed"

			@destroyCurrentUser session

			@close

		destroyCurrentUser: (session) ->
			session.set "id", "dummy_id"
			session.destroy
				success: (model, resp, options) =>
					@_resetSessionCache(resp)

		_resetSessionCache: (resp) ->
			App.userSession.clear() if App.userSession
			App.currentUser.clear() if App.currentUser
			App.currentUser = false
			$(document).ajaxSend (e, xhr, options) =>
				# reset csrf token
				xhr.setRequestHeader "X-CSRF-Token", resp.csrfToken


	App.reqres.setHandler "destroy:session", ->
		new Destroy.Controller()
