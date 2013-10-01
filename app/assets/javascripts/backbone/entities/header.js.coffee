@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

    class Entities.Header extends Entities.Models

    class Entities.HeaderCollection extends Entities.Collections
        model: Entities.Header

    API =
        getHeaders: ->
            currentUser = App.request "get:current:user"
            if currentUser
                userType = currentUser.get('type')
                if userType is "AppAdmin" 
                    @getAdminHeaders()
                else if userType is "OrgAdmin"
                    @getOrgAdminHeaders()
                else
                    @getStudentHeaders()
            else
                @getLoginHeaders()

                
        getAdminHeaders: ->
            new Entities.HeaderCollection [
                    { name: "Students", url: Routes.student_index_path().split("/api")[1] + "s" }
                    { name: "Admins", url: Routes.org_admin_index_path().split("/api")[1] + "s" }
                    { name: "Organisations", url: Routes.organisation_index_path().split("/api")[1] + "s" }
                ]

        getOrgAdminHeaders: ->
            new Entities.HeaderCollection [
                    { name: "Students", url: Routes.student_index_path().split("/api")[1] + "s" }
                    { name: "Admins", url: Routes.org_admin_index_path().split("/api")[1] + "s" }
                    { name: "Modules", url: "TODO" }
                ]

        getStudentHeaders: ->
            new Entities.HeaderCollection [
                    { name: "Modules", url: "TODO" }
                    { name: "Groups", url: "TODO" }
                    { name: "Assignments", url: "TODO" }
                ]
        getLoginHeaders: ->
            new Entities.HeaderCollection [
                    { name: "About", url: "TODO" }
                    { name: "Help", url: "TODO" }
                ]
            

    App.reqres.setHandler "header:entities", ->
        API.getHeaders()