@Learnster.module "UsersApp.New", (New, App, Backbone, Marionette, $, _) ->

	New.Controller =

		newStudentView: ->
			student = App.request "new:student:entity"
			New.Controller.layout = @getLayoutView student

			student.on "created", ->
				App.vent.trigger "student:created", student
			
			New.Controller.layout.on "show", =>
				@setFormRegion student

			New.Controller.layout
			

		getLayoutView: (student) ->
			new New.Layout
				model: student

		getNewView: (student) ->
			new New.View
				model: student

		setFormRegion: (student) ->
			@newView = @getNewView student
			formView = App.request "form:wrapper", @newView

			@newView.on "show", =>
				@setOrgSelector()

			@newView.on "form:cancel", ->
				New.Controller.layout.close()

			New.Controller.layout.formRegion.show formView


		setOrgSelector: ->
			App.request "org:entities", (orgs) =>
				App.execute "when:fetched", orgs, =>
					selectView = App.request "selects:wrapper",
												collection: orgs
												itemViewId: "attending_org"
												itemView:   App.Components.Selects.OrgOption
					@newView.orgSelectRegion.show selectView												
