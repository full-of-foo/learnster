@Learnster.module "LearningModulesApp", (LearningModulesApp, App, Backbone, Marionette, $, _) ->

  class LearningModulesApp.Router extends App.Routers.AppRouter
    appRoutes:
      "module/:id/edit" : "edit"
      "module/:id/show" : "show"
      "module/:id/supplement/:supplementId/show" : "showWithSupplement"
      "module/:moduleId/supplement/:supplementId/wiki/:wikiId/edit" : "editWiki"
      "module/:moduleId/supplement/:supplementId/wiki/:wikiId/show" : "showWiki"

  API =
    newModuleView: (region) ->
      new LearningModulesApp.New.Controller
        region: region

    edit: (id) ->
      new LearningModulesApp.Edit.Controller
        id: @get_module_id(id)

    show: (id) ->
      new LearningModulesApp.Show.Controller
        id: @get_module_id(id)

    editWiki: (moduleId, supplementId, wikiId) ->
      new App.SupplementContentsApp.Edit.Controller
        id: wikiId
        moduleId: moduleId
        supplementId: supplementId

    showWiki: (moduleId, supplementId, wikiId) ->
      new App.SupplementContentsApp.Edit.Controller
        isPreview: true
        id: wikiId
        moduleId: moduleId
        supplementId: supplementId

    showWithSupplement: (id, supplementId) ->
      new LearningModulesApp.Show.Controller
        id: @get_module_id(id)
        supplementId: @get_module_id(supplementId)

    newSectionModule: (region, orgId, courseId) ->
      new LearningModulesApp.Assign.Controller
        region: region
        orgId: orgId
        courseId: courseId

    removeSectionModule: (region, orgId, courseId) ->
      new LearningModulesApp.Unassign.Controller
        region: region
        orgId: orgId
        courseId: courseId

    get_module_id: (id_module) ->
      id = if id_module.id then id_module.id else id_module

  App.addInitializer ->
    new LearningModulesApp.Router
      controller: API

  App.commands.setHandler "new:section:module:view", (region, orgId, courseSectionId) ->
    API.newSectionModule(region, orgId, courseSectionId)

  App.commands.setHandler "remove:section:module:view", (region, orgId, courseSectionId) ->
    API.removeSectionModule(region, orgId, courseSectionId)

  App.commands.setHandler "new:module:view", (region) ->
    API.newModuleView(region)

  App.vent.on "edit:module:clicked", (view) ->
    module = view.model
    moduleId = module.get('id')
    App.navigate "/module/#{moduleId}/edit"

  App.vent.on "section_module:created", (sectionModule) ->
    sectionId = sectionModule.get('course_section_id')
    App.navigate "/course_section/#{sectionId}/show" if sectionId

  App.vent.on "modules:block:clicked", (org) ->
    orgId = org.get('id')
    isStudent = App.currentUser.get('type') is "Student"
    url = if isStudent then "/organisation/#{orgId}/my_modules" else "/organisation/#{orgId}/modules"
    App.navigate url

  App.vent.on "module:updated module:cancelled module:clicked learning_module:created", (learning_module) ->
    moduleId = learning_module.get('id')
    App.navigate "/module/#{moduleId}/show"
