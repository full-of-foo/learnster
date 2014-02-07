@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.CourseSection extends Entities.Models
    urlRoot: Routes.api_course_section_index_path()

  class Entities.CourseSectionCollection extends Entities.Collections
    model: Entities.CourseSection

    initialize: (options = {}) =>
      @url = if options.url then options.url else Routes.api_course_section_index_path()
      super


  API =
    getOrgCourseSectionEntities: (orgId) ->
      course_section = new Entities.CourseSectionCollection
        url: Routes.api_organisation_course_section_index_path(orgId)
      course_section.fetch
        reset: true
      course_section

    setCurrentCourseSection: (attrs) ->
      new Entities.CourseSection attrs

    getCourseSectionEntity: (orgId, id) ->
      course_section = new Entities.CourseSection
        url: api_organisation_course_section_index_path(orgId)
      course_section = Entities.CourseSection.findOrCreate
                                      id: id
      course_section.fetch
        reset: true
      course_section

    newCourseSection: ->
      new Entities.CourseSection

  App.reqres.setHandler "course_section:entities", (orgId) ->
    API.getOrgCourseSectionEntities(orgId)

  App.reqres.setHandler "new:course_section:entity", ->
    API.newCourseSection()

  App.reqres.setHandler "init:current:course_section", (attrs) ->
    API.setCurrentCourseSection attrs

  App.reqres.setHandler "course_section:entity", (orgId, id) ->
    API.getCourseSectionEntity orgId, id
