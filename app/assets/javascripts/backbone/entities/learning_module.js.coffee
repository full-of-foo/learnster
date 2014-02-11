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
      { term, nestedId } = searchOpts
      if nestedId
        learning_modules = new Entities.LearningModuleCollection
          url: Routes.api_organisation_learning_module_index_path(nestedId)
      else
        learning_modules = new Entities.LearningModuleCollection
      learning_modules.fetch
        reset: true
        data: $.param(term)
      learning_modules.put('search', term['search'])
      learning_modules


    newLearningModule: ->
      new Entities.LearningModule

  App.reqres.setHandler "learning_module:entities", (orgId) ->
    API.getOrgLearningModuleEntities(orgId)

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
