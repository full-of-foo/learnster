@Learnster.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.ModuleSupplement extends Entities.Models
    urlRoot: Routes.api_module_supplement_index_path()

  class Entities.ModuleSupplementCollection extends Entities.Collections
    model: Entities.ModuleSupplement

    initialize: (options = {}) =>
      @url = if options.url then options.url else Routes.api_module_supplement_index_path()
      super


  API =
    getModuleSupplement: (id) ->
      supplement = Entities.ModuleSupplement.findOrCreate
        id: id
      supplement.fetch
        reset: true
      supplement

    getModuleSupplementEntities: (moduleId) ->
      section_modules = new Entities.ModuleSupplementCollection
        url: Routes.api_module_supplement_index_path()
      section_modules.fetch
        reset: true
        data: $.param
          learning_module_id: moduleId
      section_modules

    setCurrentModuleSupplement: (attrs) ->
      new Entities.ModuleSupplement attrs

    newModuleSupplement: ->
      new Entities.ModuleSupplement


  App.reqres.setHandler "module:supplement:entities", (moduleId) ->
    API.getModuleSupplementEntities(moduleId)

  App.reqres.setHandler "new:module:supplement:entity", ->
    API.newModuleSupplement()

  App.reqres.setHandler "module:supplement:entity", (id) ->
    API.getModuleSupplement id

  App.reqres.setHandler "init:module:supplement", (attrs) ->
    API.setCurrentModuleSupplement attrs

