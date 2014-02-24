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

    getAdminOrgCourseEntities: (orgId, adminId) ->
      courses = new Entities.CourseCollection
        url: Routes.api_organisation_course_index_path(orgId)
      courses.fetch
        reset: true
        data:
          page: 1
          managed_by: adminId

      courses.put('managed_by',  adminId)
      courses

    setCurrentCourse: (attrs) ->
      new Entities.Course attrs

    getCourseEntity: (id) ->
      course = new Entities.Course
      course = Entities.Course.findOrCreate
                                      id: id
      course.fetch
        reset: true
      course

    newCourse: ->
      new Entities.Course

    getSearchCourseEntities: (searchOpts) ->
      { term, nestedId, managedId } = searchOpts
      if nestedId
        courses = new Entities.CourseCollection
          url: Routes.api_organisation_course_index_path(nestedId)
      else
        courses = new Entities.CourseCollection

      term['managed_by'] = managedId if managedId
      courses.fetch
        reset: true
        data: $.param(term)

      courses.put('search',     term['search'])
      courses.put('managed_by', term['managed_by'])
      courses


  App.reqres.setHandler "org:course:entities", (orgId) ->
    API.getOrgCourseEntities(orgId)

  App.reqres.setHandler "admin:org:course:entities", (orgId, adminId) ->
    API.getAdminOrgCourseEntities(orgId, adminId)

  App.reqres.setHandler "search:courses:entities", (searchOpts) ->
    API.getSearchCourseEntities searchOpts

  App.reqres.setHandler "new:course:entity", ->
    API.newCourse()

  App.reqres.setHandler "init:current:course", (attrs) ->
    API.setCurrentCourse attrs

  App.reqres.setHandler "course:entity", (id) ->
    API.getCourseEntity id
