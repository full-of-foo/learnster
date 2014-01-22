@Learnster.module "SidebarApp", (SidebarApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  API =
    showSidebar: ->
      user = App.request "get:current:user"
      if user instanceof Learnster.Entities.AppAdmin
        @listAppAdminSidebar()
      else if user instanceof Learnster.Entities.OrgAdmin
        @listOrgAdminSidebar()
      else if user instanceof Learnster.Entities.Student
        @listStudentSidebar()
      else
        @listLoginSidebar()

    listAppAdminSidebar: ->
      new SidebarApp.List.Controller
        type: "AppAdmin"
        region: App.sidebarRegion

    listOrgAdminSidebar: ->
      new SidebarApp.List.Controller
        type: "OrgAdmin"
        region: App.sidebarRegion

    listStudentSidebar: ->
      new SidebarApp.List.Controller
        type: "Student"
        region: App.sidebarRegion

    listLoginSidebar: ->
      new SidebarApp.List.Controller
        type: "Login"
        region: App.sidebarRegion

  App.commands.setHandler "show:sidebar", ->
    API.showSidebar()

  SidebarApp.on "start", ->
    API.showSidebar()
