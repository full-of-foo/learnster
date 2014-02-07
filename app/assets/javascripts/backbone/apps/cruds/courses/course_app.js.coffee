@Learnster.module "CoursesApp", (CoursesApp, App, Backbone, Marionette, $, _) ->

  class CoursesApp.Router extends App.Routers.AppRouter
    appRoutes:
      "course/:id/edit" : "edit"

  API =
    listCourses: ->
      new CoursesApp.List.Controller()

    newCourse: (region) ->
      new CoursesApp.New.Controller
        region: region

    edit: (id) ->
      new CoursesApp.Edit.Controller
        id: @get_org_id(id)

    get_org_id: (id_org) ->
      id = if id_org.id then id_org.id else id_org


  App.addInitializer ->
    new CoursesApp.Router
      controller: API

  App.commands.setHandler "new:course:view", (region) ->
    API.newCourse(region)

  App.vent.on "course:clicked course:created", (id) ->
    App.navigate Routes.edit_api_course_path(id).split("/api")[1]

  App.vent.on "courses:block:clicked", (org) ->
    orgId = org.id
    App.navigate "organisation/#{orgId}/courses"

  App.vent.on "course:cancelled course:updated", (course) ->
    App.goBack()
