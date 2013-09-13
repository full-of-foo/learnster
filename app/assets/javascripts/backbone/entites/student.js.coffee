@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->


    class Entities.Student extends Entities.Models
        urlRoot: Routes.student_index_path()
        relations: [
            type: Backbone.HasOne, key: 'created_by', relatedModel: Entities.AppAdmin
            type: Backbone.HasOne, key: 'attending_org', relatedModel: Entities.Org
        ]
        initialize: ->
            @on "all", (e) -> console.log e


    class Entities.StudentsCollection extends Entities.Collections
        model: Entities.Student
        url: Routes.student_index_path()


    API =
        setCurrentStudent: (currentStudent) ->
            new Entities.Student

        getStudentEntities: (cb) ->
            students = new Entities.StudentsCollection
            students.fetch
                reset: true,
                success: ->
                    cb students

        getStudentEntity: (id) ->
            student = Entities.Student.findOrCreate
                id: id
            student.fetch
                reset: true
            student

        newStudent: ->
            new Entities.Student
            

    App.reqres.setHandler "new:student:entity", ->
        API.newStudent()

    App.reqres.setHandler "set:current:student", (currentStudent) ->
        API.setCurrentStudent currentStudent

    App.reqres.setHandler "student:entities", (cb) ->
        API.getStudentEntities cb

    App.reqres.setHandler "student:entity", (id) ->
        API.getStudentEntity id