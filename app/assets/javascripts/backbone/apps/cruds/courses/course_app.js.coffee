@Learnster.module "CoursesApp", (CoursesApp, App, Backbone, Marionette, $, _) ->

  class CoursesApp.Router extends App.Routers.AppRouter
    appRoutes:
      "courses" : "listCourses"

  API =
    listCourses: ->
      new CoursesApp.List.Controller()

    newCourse: (region) ->
      new CoursesApp.New.Controller
        region: region


  App.addInitializer ->
    new CoursesApp.Router
      controller: API

  App.commands.setHandler "new:course:view", (region) ->
    API.newCourse(region)

  App.vent.on "course:clicked course:created", (id) ->
    App.navigate Routes.edit_api_course_path(id).split("/api")[1]

  App.vent.on "course:cancelled course:updated", (course) ->
    App.goBack()
