@Learnster.module "UsersApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->

	Edit.Controller =

		edit: (id) ->
			student = App.request "student:entity", id

			student.on "updated", ->
				App.vent.trigger "user:student:updated", student

			App.execute "when:fetched", student, =>
				@layout = @getLayoutView student
				@layout.on "show", =>
					@setTitleRegion student
					@setFormRegion student

				App.mainRegion.show @layout

		getLayoutView: (student) ->
			new Edit.Layout 
				model: student

		getEditView: (student) ->
			new Edit.Student
				model: student

		getTitleView: (student) ->
			new Edit.Title
				model: student

		setFormRegion: (student) ->
			editView = @getEditView student

			editView.on "form:cancel", ->
				App.vent.trigger "user:student:cancelled", student

			formView = App.request "form:wrapper", editView
			@layout.formRegion.show formView

		setTitleRegion: (student) ->
			titleView = @getTitleView student
			@layout.titleRegion.show titleView


