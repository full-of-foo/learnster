@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->


    class Entities.Student extends Entities.Models

    class Entities.StudentsCollection extends Entities.Collections
        model: Entities.Student
        url: Routes.student_index_path()

    API =
        setCurrentStudent: (currentStudent) ->
            new Entities.Student

        getStudentEntities: (cb) ->
            students = new Entities.StudentsCollection
            students.fetch
                success: ->
                    cb students

    App.reqres.setHandler "set:current:student", (currentStudent) ->
        API.setCurrentStudent currentStudent

     App.reqres.setHandler "student:entities", (cb) ->
        API.getStudentEntities cb