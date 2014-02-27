@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.LearningModule extends Entities.Models
    urlRoot: Routes.api_learning_module_index_path()

  class Entities.LearningModuleCollection extends Entities.Collections
    model: Entities.LearningModule

    initialize: (options = {}) =>
      @url = if options.url then options.url else Routes.api_learning_module_index_path()
      super


  API =
    getSectionLearningModuleEntities: (sectionId) ->
      learning_modules = new Entities.LearningModuleCollection
        url: Routes.api_learning_module_index_path()
      learning_modules.fetch
        reset: true
        data: $.param
          course_section_id: sectionId
      learning_modules

    getOrgLearningModuleEntities: (orgId) ->
      learning_modules = new Entities.LearningModuleCollection
        url: Routes.api_organisation_learning_module_index_path(orgId)
      learning_modules.fetch
        reset: true
      learning_modules

    getAdminOrgLearningModuleEntities: (orgId, adminId) ->
      learning_modules = new Entities.LearningModuleCollection
        url: Routes.api_organisation_learning_module_index_path(orgId)
      learning_modules.fetch
        reset: true
        data:
          page: 1
          educator_id: adminId

      learning_modules.put('educator_id',  adminId)
      learning_modules

    getStudentOrgLearningModuleEntities: (orgId, studentId) ->
      learning_modules = new Entities.LearningModuleCollection
        url: Routes.api_organisation_learning_module_index_path(orgId)
      learning_modules.fetch
        reset: true
        data:
          page: 1
          student_id: studentId

      learning_modules.put('student_id',  studentId)
      learning_modules

    setCurrentLearningModule: (attrs) ->
      new Entities.LearningModule attrs

    getLearningModuleEntity: (id) ->
      learning_module = new Entities.LearningModule()
      learning_module = Entities.LearningModule.findOrCreate
                                      id: id
      learning_module.fetch
        reset: true
      learning_module

    getSearchOrgLearningModuleEntities: (searchOpts) ->
      { term, nestedId, educatorId, studentId } = searchOpts
      if nestedId
        learning_modules = new Entities.LearningModuleCollection
          url: Routes.api_organisation_learning_module_index_path(nestedId)
      else
        learning_modules = new Entities.LearningModuleCollection

      term['educator_id'] = educatorId if educatorId
      term['student_id']  = studentId  if studentId
      learning_modules.fetch
        reset: true
        data: $.param(term)

      learning_modules.put('search',      term['search'])
      learning_modules.put('educator_id', term['educator_id'])
      learning_modules.put('student_id',  term['student_id'])
      learning_modules


    newLearningModule: ->
      new Entities.LearningModule

  App.reqres.setHandler "learning_module:entities", (orgId) ->
    API.getOrgLearningModuleEntities(orgId)

  App.reqres.setHandler "admin:learning_module:entities", (orgId, adminId) ->
    API.getAdminOrgLearningModuleEntities(orgId, adminId)

  App.reqres.setHandler "student:learning_module:entities", (orgId, studentId) ->
    API.getStudentOrgLearningModuleEntities(orgId, studentId)

  App.reqres.setHandler "search:learning_module:entities", (searchOpts) ->
    API.getSearchOrgLearningModuleEntities searchOpts

  App.reqres.setHandler "section:learning_module:entities", (sectionId) ->
    API.getSectionLearningModuleEntities(sectionId)

  App.reqres.setHandler "new:learning_module:entity", ->
    API.newLearningModule()

  App.reqres.setHandler "init:current:learning_module", (attrs) ->
    API.setCurrentLearningModule attrs

  App.reqres.setHandler "learning_module:entity", (id) ->
    API.getLearningModuleEntity id
