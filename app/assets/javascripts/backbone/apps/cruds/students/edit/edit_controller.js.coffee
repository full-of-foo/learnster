@Learnster.module "StudentsApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->

	class Edit.Controller extends App.Controllers.Base

		initialize: (options) ->
			id = options.id
			student = App.request "student:entity", id

			@listenTo student, "updated", ->
				App.vent.trigger "student:updated", student

			App.execute "when:fetched", student, =>
				@layout = @getLayoutView student
				@listenTo @layout, "show", =>
					@setTitleRegion student
					@setFormRegion student

				@show @layout

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

			@listenTo editView, "form:cancel", ->
				App.vent.trigger "student:cancelled", student

			formView = App.request "form:wrapper", editView
			@layout.formRegion.show formView

		setTitleRegion: (student) ->
			titleView = @getTitleView student
			@layout.titleRegion.show titleView


