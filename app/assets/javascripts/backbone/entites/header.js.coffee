@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

    class Entities.Header extends Entities.Models

    class Entities.HeaderCollection extends Entities.Collections
        model: Entities.Header

    API =
        getHeaders: ->
            new Entities.HeaderCollection [
                { name: "Students" }
                { name: "Admins" }
                { name: "Organisations" }
            ]

    App.reqres.setHandler "header:entities", ->
        API.getHeaders()