@Learnster.module "SupplementContentsApp", (SupplementContentsApp, App, Backbone, Marionette, $, _) ->

  API =
    newContent: (region, supplementId) ->
      new SupplementContentsApp.New.Controller
        region: region
        nestedSupplementId: supplementId

  App.commands.setHandler "new:content:view", (region, supplementId) ->
    API.newContent(region, supplementId)

  App.vent.on "cotent:clicked content:created", (content) ->
    console.log "clicked"
    supplementId = content.get('module_supplement').id
    moduleId = content.get('module_supplement').learning_module.id
    App.navigate "/module/#{moduleId}/supplement/#{supplementId}/show"


