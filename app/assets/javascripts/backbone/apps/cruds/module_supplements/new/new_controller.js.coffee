@Learnster.module "ModuleSupplementsApp.New", (New, App, Backbone, Marionette, $, _) ->

  class New.Controller extends App.Controllers.Base

    initialize: (options = {}) ->
      @nestedModuleId = options.nestedModuleId

      supplement = App.request "new:module:supplement:entity"
      supplement.set('learning_module_id', @nestedModuleId)

      @layout = @getLayoutView supplement

      @listenTo supplement, "created", ->
        App.vent.trigger "supplement:created", supplement

      @listenTo @layout, "show", =>
        @setFormRegion supplement

      @show @layout

    getLayoutView: (supplement) ->
      new New.Layout
        model: supplement

    getNewView: (supplement) ->
      new New.View
        model: supplement

    setFormRegion: (supplement) ->
      newView = @getNewView supplement
      formView = App.request "form:wrapper", newView

      @listenTo newView, "form:cancel", ->
        @region.close()

      @layout.formRegion.show formView
