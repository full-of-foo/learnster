@Learnster.module "CourseSectionsApp", (CourseSectionsApp, App, Backbone, Marionette, $, _) ->

  API =
    newCourse: (region, courseId) ->
      new CourseSectionsApp.New.Controller
        region: region
        courseId: courseId

  App.commands.setHandler "new:course:section:view", (region, courseId) ->
    API.newCourse(region, courseId)
