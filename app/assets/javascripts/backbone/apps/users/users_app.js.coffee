@Learnster.module "UsersApp", (UsersApp, App, Backbone, Marionette, $, _) ->

    class UsersApp.Router extends Marionette.AppRouter
        appRoutes:
            "student/:id/edit" : "edit"
            "users"            : "listUsers"


    API =
        listUsers: ->
            new UsersApp.List.Controller()

        newStudent: (region) ->
         	new UsersApp.New.Controller
                region: region

        edit: (id) ->
            new UsersApp.Edit.Controller
                    id: @get_user_id(id)

        get_user_id: (id_user) ->
            id = if id_user.id then id_user.id else id_user

    
    App.commands.setHandler "new:student:view", (region) ->
    	API.newStudent(region)

    App.vent.on "user:student:clicked student:created", (id) ->
        App.navigate Routes.edit_student_path(id).split("/api")[1]
        API.edit id

    App.vent.on "user:student:cancelled user:student:updated", (student) ->
        App.navigate Routes.student_index_path().split("/api")[1]
        API.listUsers()


   
    App.addInitializer ->
        new UsersApp.Router
            controller: API