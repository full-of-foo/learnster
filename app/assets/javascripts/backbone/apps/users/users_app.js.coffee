@Learnster.module "UsersApp", (UsersApp, App, Backbone, Marionette, $, _) ->

    class UsersApp.Router extends Marionette.AppRouter
        appRoutes:
            "users": "listUsers"


    API =
        listUsers: ->
            UsersApp.List.Controller.listUsers()

         newStudent: ->
         	UsersApp.New.Controller.newStudent()

        edit: (student) ->
            UsersApp.Edit.Controller.edit(student)

    
    App.reqres.setHandler "new:user:student:view", ->
    	API.newStudent()

    App.vent.on "user:student:clicked", (student) ->
        API.edit student

   
    App.addInitializer ->
        new UsersApp.Router
            controller: API