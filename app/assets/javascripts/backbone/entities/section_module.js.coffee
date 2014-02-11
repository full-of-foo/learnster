@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.SectionModule extends Entities.Models
    urlRoot: Routes.api_section_module_index_path()

  class Entities.SectionModuleCollection extends Entities.Collections
    model: Entities.SectionModule

    initialize: (options = {}) =>
      @url = if options.url then options.url else Routes.api_section_module_index_path()
      super


  API =
    getSectionModuleEntities: (sectionId) ->
      section_modules = new Entities.SectionModuleCollection
        url: Routes.api_section_module_index_path()
      section_modules.fetch
        reset: true
        data: $.param
          course_section_id: sectionId
      section_modules

    getOrgSectionModuleEntities: (orgId) ->
      section_modules = new Entities.SectionModuleCollection
        url: Routes.api_organisation_section_module_index_path(orgId)
      section_modules.fetch
        reset: true
      section_modules

    setCurrentSectionModule: (attrs) ->
      new Entities.SectionModule attrs

    getSectionModuleEntity: (orgId, id) ->
      section_module = new Entities.SectionModule
        url: api_organisation_section_module_index_path(orgId)
      section_module = Entities.SectionModule.findOrCreate
                                      id: id
      section_module.fetch
        reset: true
      section_module

    newSectionModule: ->
      new Entities.SectionModule

  App.reqres.setHandler "section_module:entities", (orgId) ->
    API.getOrgSectionModuleEntities(orgId)

  App.reqres.setHandler "section:section_module:entities", (sectionId) ->
    API.getSectionModuleEntities(sectionId)

  App.reqres.setHandler "new:section_module:entity", ->
    API.newSectionModule()

  App.reqres.setHandler "init:current:section_module", (attrs) ->
    API.setCurrentSectionModule attrs

  App.reqres.setHandler "section_module:entity", (orgId, id) ->
    API.getSectionModuleEntity orgId, id
