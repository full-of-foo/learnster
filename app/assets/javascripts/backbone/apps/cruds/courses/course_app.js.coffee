@Learnster.module "CoursesApp", (CoursesApp, App, Backbone, Marionette, $, _) ->

  class CoursesApp.Router extends App.Routers.AppRouter
    appRoutes:
      "course/:id/edit" : "edit"
      "course/:id/show" : "show"

  API =
    listCourses: ->
      new CoursesApp.List.Controller()

    newCourse: (region) ->
      new CoursesApp.New.Controller
        region: region

    edit: (id) ->
      new CoursesApp.Edit.Controller
        id: @get_org_id(id)

    show: (id) ->
      new CoursesApp.Show.Controller
        id: @get_org_id(id)

    get_org_id: (id_org) ->
      id = if id_org.id then id_org.id else id_org


  App.addInitializer ->
    new CoursesApp.Router
      controller: API

  App.commands.setHandler "new:course:view", (region) ->
    API.newCourse(region)

  App.vent.on "course:clicked course:created", (id) ->
    id = API.get_org_id(id)
    App.navigate "/course/#{id}/show"

  App.vent.on "courses:block:clicked", (org) ->
    orgId = org.get('id')
    isStudent = App.currentUser.get('type') is "Student"
    url = if isStudent then "/organisation/#{orgId}/my_courses" else "/organisation/#{orgId}/courses"
    App.navigate url

  App.vent.on "edit:course:clicked", (view) ->
    course = view.model
    id = course.get('id')
    App.navigate "/course/#{id}/edit"

  App.vent.on "course:cancelled course:updated", (course) ->
    App.goBack()
