@Learnster.module "EnrolledCourseSectionsApp", (EnrolledCourseSectionsApp, App, Backbone, Marionette, $, _) ->

  API =
    enrollStudentSection: (region, orgId, sectionId) ->
      new EnrolledCourseSectionsApp.Enroll.Controller
        region: region
        orgId: orgId
        sectionId: sectionId

    removeStudentSection: (region, orgId, sectionId) ->
      new EnrolledCourseSectionsApp.Remove.Controller
        region: region
        orgId: orgId
        sectionId: sectionId

    get_section_id: (id_section) ->
      id = if id_section.id then id_section.id else id_section

  App.commands.setHandler "add:student:view", (region, orgId, courseSectionId) ->
    API.enrollStudentSection(region, orgId, courseSectionId)

  App.commands.setHandler "remove:student:view", (region, orgId, courseSectionId) ->
    API.removeStudentSection(region, orgId, courseSectionId)


