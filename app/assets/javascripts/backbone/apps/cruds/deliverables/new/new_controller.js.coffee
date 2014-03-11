@Learnster.module "DeliverablesApp.New", (New, App, Backbone, Marionette, $, _) ->

  class New.Controller extends App.Controllers.Base

    initialize: (options = {}) ->
      @nestedSupplementId = options.nestedSupplementId

      deliverable = App.request "new:deliverable:entity"
      deliverable.set('module_supplement', {id: @nestedSupplementId})

      @layout = @getLayoutView deliverable

      @listenTo deliverable, "created", (new_deliverable) =>
        @layout.close()
        App.request "show:deliverable", new_deliverable

      @listenTo @layout, "show", =>
          @showFormRegion(deliverable)

      @show @layout

    getLayoutView: (deliverable) ->
      new New.Layout
        model: deliverable

    getNewDeliverable: (deliverable) ->
      new New.Deliverable
        model: deliverable

    showFormRegion: (deliverable) ->
      @newView = @getNewDeliverable deliverable
      formView = App.request "form:wrapper", @newView,
        toast:
          message: "deliverable created"

      @listenTo @newView, "form:cancel", ->
        @region.close()

      @show formView,
        loading:
            loadingType: "spinner"
        region:  @layout.formRegion
