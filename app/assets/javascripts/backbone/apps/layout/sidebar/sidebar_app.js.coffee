@Learnster.module "SidebarApp", (SidebarApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  API =
    showSidebar: ->
      user = App.request "get:current:user"
      if user instanceof Learnster.Entities.AppAdmin
        @listAppAdminSidebar()

      else if user instanceof Learnster.Entities.OrgAdmin
        switch user.get('role')
          when "course_manager" then @listCourseAdminSidebar()
          when "module_manager" then @listModuleAdminSidebar()
          when "account_manager" then @listAccountAdminSidebar()

      else if user instanceof Learnster.Entities.Student
        @listStudentSidebar()

      else
        @listLoginSidebar()

    listAppAdminSidebar: ->
      new SidebarApp.List.Controller
        type: "AppAdmin"
        region: App.sidebarRegion

    listAccountAdminSidebar: ->
      new SidebarApp.List.Controller
        type: "account_manager"
        region: App.sidebarRegion

    listCourseAdminSidebar: ->
      new SidebarApp.List.Controller
        type: "course_manager"
        region: App.sidebarRegion

    listModuleAdminSidebar: ->
      new SidebarApp.List.Controller
        type: "module_manager"
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

  App.commands.setHandler "side:higlight:item", (id) ->
    App.commands.execute "clear:sidebar:higlight"
    $("##{id}").parent().addClass('active')

  App.commands.setHandler "clear:sidebar:higlight", ->
    $('#sidebar-region ul li').removeClass('active')

  SidebarApp.on "start", ->
    API.showSidebar()
