@Learnster.module "OrgsApp", (OrgsApp, App, Backbone, Marionette, $, _) ->


  class OrgsApp.Router extends App.Routers.AppRouter
    appRoutes:
      "organisation/:id/edit"             : "edit"
      "organisation/:id/students"         : "listOrgStudents"
      "organisation/:id/my_students"      : "listMyOrgStudents"
      "organisation/:id/admins"           : "listOrgAdmins"
      "organisation/:id/my_admins"        : "listMyOrgAdmins"
      "organisation/:id/notifications"    : "listOrgNotifications"
      "organisation/:id/dashboard"        : "listDashBlocks"
      "organisation/:id/courses"          : "listOrgCourses"
      "organisation/:id/my_courses"       : "listMyOrgCourses"
      "organisation/:id/modules"          : "listOrgModules"
      "organisation/:id/my_modules"       : "listMyOrgModules"
      "organisation/:id/my_deliverables"  : "listMyDeliverables"
      "organisation/:id/my_settings"      : "showMySettings"
      "organisations"                     : "listOrgs"

  API =
    newOrg: (region) ->
      new OrgsApp.New.Controller
        region: region

    listOrgs: ->
      new OrgsApp.List.Controller()

    listDashBlocks: (id) ->
      new App.DashApp.List.Controller
        id: @get_org_id(id)

    listOrgStudents: (id) ->
      new App.StudentsApp.List.Controller
        id: @get_org_id(id)

    listMyOrgStudents: (id) ->
      new App.StudentsApp.List.Controller
        id: @get_org_id(id)
        isMyStudents: true

    listOrgAdmins: (id) ->
      new App.OrgAdminsApp.List.Controller
        id: @get_org_id(id)

    listMyOrgAdmins: (id) ->
      new App.OrgAdminsApp.List.Controller
        id: @get_org_id(id)
        isMyAdmins: true

    listOrgNotifications: (id) ->
      new App.NotificationsApp.List.Controller
        id: @get_org_id(id)

    listOrgCourses: (id) ->
      new App.CoursesApp.List.Controller
        id: @get_org_id(id)

    listMyOrgCourses: (id) ->
      new App.CoursesApp.List.Controller
        id: @get_org_id(id)
        isMyCourses: true

    listOrgModules: (id) ->
      new App.LearningModulesApp.List.Controller
        id: @get_org_id(id)

    listMyOrgModules: (id) ->
      new App.LearningModulesApp.List.Controller
        id: @get_org_id(id)
        isMyModules: true

    listMyDeliverables: (id) ->
      new App.DeliverablesApp.List.Controller
        id: @get_org_id(id)

    showMySettings: (id) ->
      new App.SettingsApp.Edit.Controller
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

  App.vent.on "link-org-students:clicked list-org-students:clicked", (id) ->
    App.navigate(Routes.api_organisation_student_index_path(id).split("/api")[1] + "s")

  App.vent.on "link-org-admins:clicked list-org-admins:clicked", (id) ->
    App.navigate("/organisation/#{API.get_org_id(id)}/admins")

  App.vent.on "org:cancelled org:updated", (org) ->
    App.goBack()

  App.vent.on "notifications:link:clicked", ->
    user = App.reqres.request("get:current:user")
    switch user.get('type')
      when "AppAdmin" then App.navigate("/notifications")
      when "OrgAdmin" then App.navigate("/organisation/#{user.get('admin_for').id}/notifications")
      when "Student"  then App.navigate("/organisation/#{user.get('attending_org').id}/notifications")


  App.addInitializer ->
    new OrgsApp.Router
      controller: API
