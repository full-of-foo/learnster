@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->


	class Entities.Student extends Entities.Models
		urlRoot: Routes.api_student_index_path()


	class Entities.StudentsCollection extends Entities.Collections
		model: Entities.Student

		initialize: (options = {}) =>
			@url = if not options.url then Routes.api_student_index_path() else options.url
			super


	API =
		setCurrentStudent: (attrs) ->
			new Entities.Student attrs

		getStudentEntities: ->
			students = new Entities.StudentsCollection
			students.fetch
				reset: true
			students

		getOrgStudentEntities: (orgId) ->
			students = new Entities.StudentsCollection
											url: Routes.api_organisation_student_index_path(orgId)
			students.fetch
				reset: true
			students

		getStudentEntity: (id) ->
			student = Entities.Student.findOrCreate
				id: id
			student.fetch
				reset: true
			student

		newStudent: ->
			new Entities.Student()

		getSearchStudentEntities: (searchOpts) ->
			{ term, nestedId } = searchOpts
			if nestedId
				students = new Entities.StudentsCollection
										 url: Routes.api_organisation_student_index_path(nestedId)
			else
				students = new Entities.StudentsCollection

			console.log $.param(term)
			students.fetch
				reset: true
				data: $.param(term)
			students

	App.reqres.setHandler "new:student:entity", ->
		API.newStudent()

	App.reqres.setHandler "init:current:student", (attrs) ->
		API.setCurrentStudent attrs

	App.reqres.setHandler "org:student:entities", (orgId) ->
		API.getOrgStudentEntities(orgId)

	App.reqres.setHandler "student:entities", ->
		API.getStudentEntities()

	App.reqres.setHandler "student:entity", (id) ->
		API.getStudentEntity id

	App.reqres.setHandler "search:students:entities", (searchOpts) ->
		API.getSearchStudentEntities searchOpts