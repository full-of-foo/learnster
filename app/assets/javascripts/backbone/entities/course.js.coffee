@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Course extends Entities.Models
    urlRoot: Routes.api_course_index_path()

  class Entities.CourseCollection extends Entities.Collections
    model: Entities.Course

    initialize: (options = {}) =>
      @url = if options.url then options.url else Routes.api_course_index_path()
      super


  API =
    getOrgCourseEntities: (orgId) ->
      courses = new Entities.CourseCollection
        url: Routes.api_organisation_course_index_path(orgId)
      courses.fetch
        reset: true
      courses

    setCurrentCourse: (attrs) ->
      new Entities.Course attrs

    getCourseEntity: (orgId, id) ->
      course = new Entities.Course
        url: api_organisation_course_index_path(orgId)
      course = Entities.Course.findOrCreate
                                      id: id
      course.fetch
        reset: true
      course

    newCourse: ->
      new Entities.Course

  App.reqres.setHandler "org:course:entities", (orgId) ->
    API.getOrgCourseEntities(orgId)

  App.reqres.setHandler "new:course:entity", ->
    API.newCourse()

  App.reqres.setHandler "init:current:course", (attrs) ->
    API.setCurrentCourse attrs

  App.reqres.setHandler "course:entity", (orgId, id) ->
    API.getCourseEntity orgId, id
