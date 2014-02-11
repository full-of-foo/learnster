@Learnster.module "LearningModulesApp", (LearningModulesApp, App, Backbone, Marionette, $, _) ->

  # class LearningModulesApp.Router extends App.Routers.AppRouter
  #   appRoutes:
  #     # "modules/:id/edit" : "edit"
  #     # "course/:id/show" : "show"

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

  App.vent.on "modules:block:clicked", (org) ->
    orgId = org.get('id')
    App.navigate "/organisation/#{orgId}/modules"
