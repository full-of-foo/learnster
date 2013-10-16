@Learnster.module "OrgAdminsApp.New", (New, App, Backbone, Marionette, $, _) ->

	class New.Controller extends App.Controllers.Base

		initialize: (options = {}) ->
			@_nestingOrg = options.region?._nestingOrg

			org_admin = App.request "new:org_admin:entity"
			@layout = @getLayoutView org_admin

			@listenTo org_admin, "created", ->
				App.vent.trigger "org_admin:created", org_admin

			@listenTo @layout, "show", =>
				@setFormRegion org_admin

			@show @layout


		getLayoutView: (org_admin) ->
			new New.Layout
				model: org_admin

		getNewView: (org_admin) ->
			new New.View
				model: org_admin

		setFormRegion: (org_admin) ->
			@newView = @getNewView org_admin
			formView = App.request "form:wrapper", @newView

			user = App.request "get:current:user"

			if user.get('type') is "AppAdmin"
				@listenTo @newView, "show", ->
					@setOrgSelector()

			@listenTo @newView, "form:cancel", =>
				@region.close()

			@layout.formRegion.show formView


		setOrgSelector: ->
			if @_nestingOrg
				orgs = App.request("new:org:entities")
				orgs.push(@_nestingOrg)
			else
			 	orgs = App.request("org:entities")

			selectView = App.request "selects:wrapper",
										collection: orgs
										itemViewId: "admin_for"
										itemView:   App.Components.Selects.OrgOption
			@show selectView,
                            loading:
                                loadingType: "spinner"
                            region:  @newView.orgSelectRegion
