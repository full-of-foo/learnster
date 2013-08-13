@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->


    class Entities.User extends Entities.Models

    class Entities.UsersCollection extends Entities.Collections
        model: Entities.User

    API =
        setCurrentUser: (currentUser) ->
            new Entities.User currentUser


    App.reqres.setHandler "set:current:user", (currentUser) ->
        API.setCurrentUser currentUser