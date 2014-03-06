@Learnster.module "SubmissionsApp", (SubmissionsApp, App, Backbone, Marionette, $, _) ->

  API =
    newUploadSubmission: (region, deliverableId) ->
      new SubmissionsApp.New.Controller
        region: region
        isUpload: true
        nestedDeliverableId: deliverableId

    newWikiSubmission: (region, deliverableId) ->
      new SubmissionsApp.New.Controller
        region: region
        isUpload: false
        nestedDeliverableId: deliverableId

  App.commands.setHandler "new:submission:upload:view", (region, deliverableId) ->
    API.newUploadSubmission(region, deliverableId)

  App.commands.setHandler "new:wiki:submission:view", (region, deliverableId) ->
    API.newWikiSubmission(region, deliverableId)

  App.vent.on "submission:created", (submission) ->
    deliverableId = submission.get('deliverable').id
    App.navigate "/deliverable/#{deliverableId}/show"

  App.vent.on "wiki:submission:clicked submission:clicked  wiki:submission:updated wiki:submission:cancelled"
    , (wikiSubmission) ->
      wikiId = wikiSubmission.get('id')
      deliverableId = wikiSubmission.get('deliverable').id
      App.navigate "/deliverable/#{deliverableId}/wiki_submission/#{wikiId}/show"

  App.vent.on "edit:wiki:submission", (wikiSubmission) ->
    wikiId = wikiSubmission.get('id')
    deliverableId = wikiSubmission.get('deliverable').id
    App.navigate "/deliverable/#{deliverableId}/wiki_submission/#{wikiId}/edit"

