@Learnster.module "DeliverablesApp", (DeliverablesApp, App, Backbone, Marionette, $, _) ->

  class DeliverablesApp.Router extends App.Routers.AppRouter
    appRoutes:
      "deliverable/:id/show"            : "show"
      "deliverable/:id/edit"            : "edit"
      "deliverable/:deliverableId/wiki_submission/:id/show" : "showWiki"
      "deliverable/:deliverableId/wiki_submission/:id/edit" : "editWiki"
      "deliverable/:deliverableId/wiki_submission/:id/version/:versionId/show" : "showVersion"


  App.addInitializer ->
    new DeliverablesApp.Router
      controller: API

  API =
    show: (id) ->
      new DeliverablesApp.Show.Controller
        id: @get_deliverable_id(id)

    edit: (id) ->
      new DeliverablesApp.Edit.Controller
        id: @get_deliverable_id(id)

    showWiki: (deliverableId, id) ->
      new App.SubmissionsApp.Edit.Controller
        deliverableId: deliverableId
        id:            id
        isPreview:     true

    editWiki: (deliverableId, id) ->
      new App.SubmissionsApp.Edit.Controller
        deliverableId: deliverableId
        id:            id
        isPreview:     false

    showVersion: (deliverableId, id, versionId) ->
      new App.SubmissionsApp.Edit.Controller
        deliverableId: deliverableId
        id:            id
        versionId:     versionId
        isPreview:     false

    newDeliverable: (region, supplementId) ->
      new DeliverablesApp.New.Controller
        region: region
        nestedSupplementId: supplementId

    get_deliverable_id: (deliverable_or_id) ->
      if deliverable_or_id.attributes then deliverable_or_id.get('id') else deliverable_or_id

  App.reqres.setHandler "show:deliverable", (deliverable) ->
    App.navigate "/deliverable/#{deliverable.get('id')}/show"

  App.commands.setHandler "new:deliverable:view", (region, supplementId) ->
    API.newDeliverable(region, supplementId)


