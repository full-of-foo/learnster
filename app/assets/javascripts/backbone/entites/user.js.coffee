@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->


    class Entities.User extends Entities.Models

    class Entities.UsersCollection extends Entities.Collections
        model: Entities.User
        url: Routes.user_index_path()

    API =
        setCurrentUser: (currentUser) ->
            new Entities.User

        getUserEntities: (cb) ->
            users = new Entities.UsersCollection
            users.fetch
                reset: true,
                success: ->
                    cb users

    App.reqres.setHandler "set:current:user", (currentUser) ->
        API.setCurrentUser currentUser

     App.reqres.setHandler "user:entities", (cb) ->
        API.getUserEntities cb