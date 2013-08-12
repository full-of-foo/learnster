@Learnster.module "Entites", (Entites, App, Backbone, Marionette, $, _) ->

    class Entites.Header extends Entites.Models

    class Entites.HeaderCollection extends Entites.Collections
        model: Entites.Header

    API =
        getHeaders: ->
            new Entites.HeaderCollection [
                { name: "Students" }
                { name: "Admins" }
                { name: "Organisations" }
            ]

    App.reqres.setHandler "header:entities", ->
        API.getHeaders()