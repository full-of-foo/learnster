@Learnster.module "SidebarApp", (SidebarApp, App, Backbone, Marionette, $, _) ->

    class SidebarApp.Router extends Marionette.AppRouter
        appRoutes:
            "login":     "listLoginSidebar"
            "admin":     "listOrgAdminSidebar"
            "app-admin": "listAppAdminSidebar"


    API =
        listLoginSidebar: ->
            new SidebarApp.List.Controller
                                type: "login"

        listOrgAdminSidebar: ->
            new SidebarApp.List.Controller
                                type: "orgAdmin"

        listAppAdminSidebar: ->
            new SidebarApp.List.Controller
                                type: "appAdmin"

    App.addInitializer ->
        new SidebarApp.Router
            controller: API
