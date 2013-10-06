@Learnster.module "OrgAdminsApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->

	class Edit.Controller extends App.Controllers.Base

		initialize: (options) ->
			id = options.id
			org_admin = App.request "org_admin:entity", id

			@listenTo org_admin, "updated", ->
				App.vent.trigger "org_admin:updated", org_admin

			App.execute "when:fetched", org_admin, =>
				@layout = @getLayoutView org_admin
				@listenTo @layout, "show", =>
					@setTitleRegion org_admin
					@setFormRegion org_admin

				@show @layout

		getLayoutView: (org_admin) ->
			new Edit.Layout 
				model: org_admin

		getEditView: (org_admin) ->
			new Edit.OrgAdmin
				model: org_admin

		getTitleView: (org_admin) ->
			new Edit.Title
				model: org_admin

		setFormRegion: (org_admin) ->
			editView = @getEditView org_admin

			@listenTo editView, "form:cancel", ->
				App.vent.trigger "org_admin:cancelled", org_admin

			formView = App.request "form:wrapper", editView
			@layout.formRegion.show formView

		setTitleRegion: (org_admin) ->
			titleView = @getTitleView org_admin
			@layout.titleRegion.show titleView


