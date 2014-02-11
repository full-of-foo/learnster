@Learnster.module "LearningModulesApp", (LearningModulesApp, App, Backbone, Marionette, $, _) ->

  API =
    newSectionModule: (region, orgId, courseId) ->
      new LearningModulesApp.Assign.Controller
        region: region
        orgId: orgId
        courseId: courseId

  App.commands.setHandler "new:section:module:view", (region, orgId, courseSectionId) ->
    API.newSectionModule(region, orgId, courseSectionId)

  App.vent.on "section_module:created", (sectionModule) ->
    sectionId = sectionModule.get('course_section_id')
    App.navigate "/course_section/#{sectionId}/show" if sectionId
