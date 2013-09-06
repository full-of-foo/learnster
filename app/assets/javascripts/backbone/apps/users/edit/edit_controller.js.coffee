@Learnster.module "UsersApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->

	Edit.Controller =

		edit: (id) ->
			student = App.request "student:entity", id
			App.execute "when:fetched", student, =>
				@layout = @getLayoutView student
				@layout.on "show", =>
					@setFormRegion student

				App.mainRegion.show @layout

		getLayoutView: (student) ->
			new Edit.Layout 
				model: student

		setFormRegion: (student) ->
			editView = @getEditView student
			formView = App.request "form:wrapper", editView
			@layout.formRegion.show formView


		getEditView: (student) ->
			new Edit.Student
				model: student