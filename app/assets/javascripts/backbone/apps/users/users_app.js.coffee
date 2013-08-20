@Learnster.module "UsersApp", (UsersApp, App, Backbone, Marionette, $, _) ->

    class UsersApp.Router extends Marionette.AppRouter
        appRoutes:
            "student/:id/edit" : "edit"
            "users"            : "listUsers"


    API =
        listUsers: ->
            UsersApp.List.Controller.listUsers()

         newStudent: ->
         	UsersApp.New.Controller.newStudent()

        edit: (id, student) ->
            UsersApp.Edit.Controller.edit(id, student)

    
    App.reqres.setHandler "new:user:student:view", ->
    	API.newStudent()

    App.vent.on "user:student:clicked", (student) ->
        App.navigate Routes.edit_student_path(student.id).split("/api")[1]
        API.edit student.id, student

   
    App.addInitializer ->
        new UsersApp.Router
            controller: API