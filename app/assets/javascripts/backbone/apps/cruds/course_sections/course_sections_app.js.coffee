@Learnster.module "CourseSectionsApp", (CourseSectionsApp, App, Backbone, Marionette, $, _) ->

  class CourseSectionsApp.Router extends App.Routers.AppRouter
    appRoutes:
      "course_section/:id/edit" : "edit"
      "course_section/:id/show" : "show"

  API =
    newCourseSection: (region, courseId) ->
      new CourseSectionsApp.New.Controller
        region: region
        courseId: courseId

    edit: (id) ->
      new CourseSectionsApp.Edit.Controller
        id: @get_section_id(id)

    show: (id) ->
      new CourseSectionsApp.Show.Controller
        id: @get_section_id(id)

    get_section_id: (id_section) ->
      id = if id_section.id then id_section.id else id_section


  App.addInitializer ->
    new CourseSectionsApp.Router
      controller: API

  App.commands.setHandler "new:course:section:view", (region, courseId) ->
    API.newCourseSection(region, courseId)

  App.vent.on "course_section:clicked course_section:created", (id) ->
    id = API.get_section_id(id)
    App.navigate "/course_section/#{id}/show"

  App.vent.on "edit:course_section:clicked", (view) ->
    course_section = view.model
    id = course_section.get('id')
    App.navigate "/course_section/#{id}/edit"

  App.vent.on "course_section:cancelled course_section:updated", (course_section) ->
    App.goBack()
