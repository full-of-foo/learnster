@Learnster.module "SidebarApp", (SidebarApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  API =
    showSidebar: ->
      user = App.request "get:current:user"
      if user instanceof Learnster.Entities.AppAdmin
        @sidebar = @listAppAdminSidebar()
      else if user instanceof Learnster.Entities.OrgAdmin
        @sidebar = @listOrgAdminSidebar()
      else if user instanceof Learnster.Entities.Student
        @sidebar = @listStudentSidebar()
      else
        @sidebar = @listLoginSidebar()

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

  App.reqres.setHandler "get:sidebar:controller", ->
    API.sidebar

  SidebarApp.on "start", ->
    API.showSidebar()
