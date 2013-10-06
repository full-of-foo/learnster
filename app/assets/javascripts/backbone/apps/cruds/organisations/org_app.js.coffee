@Learnster.module "OrgsApp", (OrgsApp, App, Backbone, Marionette, $, _) ->


    class OrgsApp.Router extends Marionette.AppRouter
        appRoutes:
                "organisation/:id/edit"       : "edit"
                "organisation/:id/students"   : "listOrgStudents"
                "organisation/:id/admins"     : "listOrgAdmins"
                "organisations"               : "listOrgs"


    API =  
        newOrg: (region) ->
            new OrgsApp.New.Controller
                            region: region

        listOrgs: ->
            new OrgsApp.List.Controller()

        listOrgStudents: (id) ->
            new App.StudentsApp.List.Controller
                                    id: @get_org_id(id)

        listOrgAdmins: (id) ->
            new App.OrgAdminsApp.List.Controller
                                    id: @get_org_id(id)

         edit: (id) ->
            new OrgsApp.Edit.Controller
                    id: @get_org_id(id)

        get_org_id: (id_org) ->
            id = if id_org.id then id_org.id else id_org

    
    App.commands.setHandler "new:org:view", (region) ->
        API.newOrg(region)

    App.vent.on "org:clicked org:created", (id) ->
        App.navigate Routes.edit_api_organisation_path(id).split("/api")[1]
        API.edit id

    App.vent.on "link-org-students:clicked list-org-students:clicked", (id) ->
        App.navigate Routes.api_organisation_student_index_path(id).split("/api")[1] + "s"
        API.listOrgStudents id

    App.vent.on "link-org-admins:clicked list-org-admins:clicked", (id) ->
        App.navigate Routes.api_organisation_admin_index_path(id).split("/api")[1] + "s"
        API.listOrgAdmins id

    App.vent.on "org:cancelled org:updated", (org) ->
        App.navigate Routes.api_organisation_index_path().split("/api")[1] + "s"
        API.listOrgs()



    App.addInitializer ->
        new OrgsApp.Router 
                controller: API