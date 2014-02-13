@Learnster.module "ModuleSupplementsApp", (ModuleSupplementsApp, App, Backbone, Marionette, $, _) ->

  API =
    newSupplement: (region, moduleId) ->
      new ModuleSupplementsApp.New.Controller
        region: region
        nestedModuleId: moduleId

    showSupplement: (region, supplement) ->
      new ModuleSupplementsApp.Show.Controller
        region: region
        supplement: supplement

  App.commands.setHandler "new:supplement:view", (region, moduleId) ->
    API.newSupplement(region, moduleId)

  App.commands.setHandler "show:supplement:view", (region, supplement) ->
    API.showSupplement(region, supplement)

  App.vent.on "supplement:created", (supplement) ->
    moduleId = supplement.get('learning_module_id')
    supplementId = supplement.get('id')
    App.navigate "/module/#{moduleId}/supplement/#{supplementId}/show"
