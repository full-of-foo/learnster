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
        data:
          page: 1
        reset: true
      students

    getOrgStudentEntities: (orgId) ->
      students = new Entities.StudentsCollection
        url: Routes.api_organisation_student_index_path(orgId)
      students.fetch
        data:
            page: 1
        reset: true
      students

    getAdminStudentEntities: (orgId, adminId) ->
      students = new Entities.StudentsCollection
        url: Routes.api_organisation_student_index_path(orgId)
      students.fetch
        data:
            page: 1
            created_by: adminId
        reset: true
      students.put('created_by',  adminId)
      students

    getStudentCoursemateEntities: (orgId, studentId) ->
      students = new Entities.StudentsCollection
        url: Routes.api_organisation_student_index_path(orgId)
      students.fetch
        data:
            page: 1
            student_id: studentId
        reset: true
      students.put('student_id',  studentId)
      students


    getSectionStudentEntities: (sectionId) ->
      students = new Entities.StudentsCollection
      students.fetch
        data:
            page: 1
            section_id: sectionId
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
      { term, nestedId, owningId, studentId } = searchOpts
      if nestedId
        students = new Entities.StudentsCollection
          url: Routes.api_organisation_student_index_path(nestedId)
      else
        students = new Entities.StudentsCollection

      term['created_by'] = owningId  if owningId
      term['student_id'] = studentId if studentId
      students.fetch
        reset: true
        data: $.param(term)

      students.put('search', term['search'])
      students.put('created_by', term['created_by']) if owningId
      students.put('student_id', term['student_id']) if studentId
      students

  App.reqres.setHandler "new:student:entity", ->
    API.newStudent()

  App.reqres.setHandler "init:current:student", (attrs) ->
    API.setCurrentStudent attrs

  App.reqres.setHandler "org:student:entities", (orgId) ->
    API.getOrgStudentEntities(orgId)

  App.reqres.setHandler "admin:student:entities", (orgId, adminId) ->
    API.getAdminStudentEntities(orgId, adminId)

  App.reqres.setHandler "student:coursemate:entities", (orgId, student) ->
    API.getStudentCoursemateEntities(orgId, student)

  App.reqres.setHandler "section:student:entities", (sectionId) ->
    API.getSectionStudentEntities(sectionId)

  App.reqres.setHandler "student:entities", ->
    API.getStudentEntities()

  App.reqres.setHandler "student:entity", (id) ->
    API.getStudentEntity id

  App.reqres.setHandler "search:students:entities", (searchOpts) ->
    API.getSearchStudentEntities searchOpts
