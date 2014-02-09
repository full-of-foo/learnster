@Learnster.module "CourseSectionsApp", (CourseSectionsApp, App, Backbone, Marionette, $, _) ->

  API =
    newCourse: (region) ->
      new CourseSectionsApp.New.Controller
        region: region

  App.commands.setHandler "new:course:view", (region) ->
    API.newCourse(region)
