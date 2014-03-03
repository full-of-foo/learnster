@Learnster.module "SupplementContentsApp", (SupplementContentsApp, App, Backbone, Marionette, $, _) ->

  API =
    newUploadContent: (region, supplementId) ->
      new SupplementContentsApp.New.Controller
        region: region
        isUpload: true
        nestedSupplementId: supplementId

    newWikiContent: (region, supplementId) ->
      new SupplementContentsApp.New.Controller
        region: region
        isUpload: false
        nestedSupplementId: supplementId


  App.commands.setHandler "new:content:upload:view", (region, supplementId) ->
    API.newUploadContent(region, supplementId)

  App.commands.setHandler "new:wiki:content:view", (region, supplementId) ->
    API.newWikiContent(region, supplementId)

  App.vent.on "content:clicked content:created", (content) ->
    supplementId = content.get('module_supplement').id
    moduleId = content.get('module_supplement').learning_module.id
    App.navigate "/module/#{moduleId}/supplement/#{supplementId}/show"

  App.vent.on "wiki:content:clicked", (wikiContent) ->
    wikiId = wikiContent.get('id')
    supplementId = wikiContent.get('module_supplement').id
    moduleId = wikiContent.get('module_supplement').learning_module.id
    App.navigate "/module/#{moduleId}/supplement/#{supplementId}/wiki/#{wikiId}/show"

