@Learnster.module "StudentsApp.New", (New, App, Backbone, Marionette, $, _) ->

	class New.Controller extends App.Controllers.Base

		initialize: (options) ->
			student = App.request "new:student:entity"
			@layout = @getLayoutView student

			@listenTo student, "created", ->
				App.vent.trigger "student:created", student
			
			@listenTo @layout, "show", =>
				@setFormRegion student

			@show @layout
			

		getLayoutView: (student) ->
			new New.Layout
				model: student

		getNewView: (student) ->
			new New.View
				model: student

		setFormRegion: (student) ->
			@newView = @getNewView student
			formView = App.request "form:wrapper", @newView

			@listenTo @newView, "show", ->
				@setOrgSelector()

			@listenTo @newView, "form:cancel", =>
				@region.close()

			@layout.formRegion.show formView


		setOrgSelector: ->
			App.request "org:entities", (orgs) =>
				App.execute "when:fetched", orgs, =>
					selectView = App.request "selects:wrapper",
												collection: orgs
												itemViewId: "attending_org"
												itemView:   App.Components.Selects.OrgOption
					@newView.orgSelectRegion.show selectView												
