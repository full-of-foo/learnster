@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.EnrolledCourseSection extends Entities.Models
    urlRoot: Routes.api_enrolled_course_section_index_path()

  class Entities.EnrolledCourseSectionCollection extends Entities.Collections
    model: Entities.EnrolledCourseSection

  API =
    setCurrentEnrolledCourseSection: (attrs) ->
      new Entities.EnrolledCourseSection attrs

    newEnrolledCourseSection: ->
      new Entities.EnrolledCourseSection

  App.reqres.setHandler "new:enrolled:course:section:entity", ->
    API.newEnrolledCourseSection()

  App.reqres.setHandler "init:enrolled:course:section", (attrs) ->
    API.setCurrentEnrolledCourseSection attrs

