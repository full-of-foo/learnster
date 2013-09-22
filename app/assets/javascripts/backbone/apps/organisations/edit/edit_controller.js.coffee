@Learnster.module "OrgsApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->

	class Edit.Controller extends App.Controllers.Base

		initialize: (options) ->
			id = options.id
			org = App.request "org:entity", id
			
			@listenTo org, "updated", ->
				App.vent.trigger "org:updated", org

			App.execute "when:fetched", org, =>
				@layout = @getLayoutView org
				@listenTo @layout, "show", =>
					@setTitleRegion org
					@setFormRegion org

				@show @layout

		getLayoutView: (org) ->
			new Edit.Layout 
				model: org

		getEditView: (org) ->
			new Edit.Org
				model: org

		getTitleView: (org) ->
			new Edit.Title
				model: org

		setFormRegion: (org) ->
			editView = @getEditView org

			@listenTo editView, "form:cancel", ->
				App.vent.trigger "org:cancelled", org

			@listenTo editView, "org-students:clicked", ->
				App.vent.trigger "link-org-students:clicked", org

			formView = App.request "form:wrapper", editView
			@layout.formRegion.show formView

		setTitleRegion: (org) ->
			titleView = @getTitleView org
			@layout.titleRegion.show titleView


