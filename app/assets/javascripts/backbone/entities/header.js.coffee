@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

    class Entities.Header extends Entities.Models

    class Entities.HeaderCollection extends Entities.Collections
        model: Entities.Header

    API =
        getHeaders: ->
            new Entities.HeaderCollection [
                { name: "Students", url: Routes.student_index_path().split("/api")[1] + "s" }
                { name: "Admins", url: Routes.org_admin_index_path().split("/api")[1] + "s" }
                { name: "Organisations", url: Routes.organisation_index_path().split("/api")[1] + "s" }
            ]

    App.reqres.setHandler "header:entities", ->
        API.getHeaders()