@Learnster.module "ModuleSupplementsApp", (ModuleSupplementsApp, App, Backbone, Marionette, $, _) ->

  API =
    newSupplement: (region, moduleId) ->
      new ModuleSupplementsApp.New.Controller
        region: region
        nestedModuleId: moduleId

  App.commands.setHandler "new:supplement:view", (region, moduleId) ->
    API.newSupplement(region, moduleId)

  App.vent.on "supplement:created", (supplement) ->
    moduleId = supplement.get('learning_module_id')
    App.navigate "/module/#{moduleId}/show"
