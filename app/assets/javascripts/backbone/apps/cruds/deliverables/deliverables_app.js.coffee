@Learnster.module "DeliverablesApp", (DeliverablesApp, App, Backbone, Marionette, $, _) ->

  class DeliverablesApp.Router extends App.Routers.AppRouter
    appRoutes:
      "deliverable/:id/show"    : "show"
      "deliverable/:id/edit"    : "edit"


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

