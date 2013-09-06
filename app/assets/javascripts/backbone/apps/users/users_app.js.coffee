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

        edit: (id) ->
            UsersApp.Edit.Controller.edit(@get_user_id(id))

        get_user_id: (id_user) ->
            id = if id_user.id then id_user.id else id_user

    
    App.reqres.setHandler "new:user:student:view", ->
    	API.newStudent()

    App.vent.on "user:student:clicked", (id) ->
        App.navigate Routes.edit_student_path(id).split("/api")[1]
        API.edit id

   
    App.addInitializer ->
        new UsersApp.Router
            controller: API