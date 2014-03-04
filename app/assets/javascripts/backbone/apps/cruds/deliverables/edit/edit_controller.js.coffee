@Learnster.module "DeliverablesApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.Controller extends App.Controllers.Base

    initialize: (options) ->
      id = options.id
      deliverable = App.request "deliverable:entity", id

      @listenTo deliverable, "updated", ->
        App.vent.trigger "deliverable:updated", deliverable

      @layout = @getLayoutView deliverable
      @listenTo @layout, "show", =>
        @setTitleRegion deliverable
        @setFormRegion deliverable

      @show @layout

    getLayoutView: (deliverable) ->
      new Edit.Layout
        model: deliverable

    getEditView: (deliverable) ->
      new Edit.Deliverable
        model: deliverable

    getTitleView: (deliverable) ->
      new Edit.Title
        model: deliverable

    setFormRegion: (deliverable) ->
      editView = @getEditView deliverable
      @listenTo editView, "form:cancel", ->
        App.vent.trigger "deliverable:cancelled", deliverable

      formView = App.request "form:wrapper", editView
      console.log formView
      @show formView,
        loading:
          loadingType: "spinner"
        region:  @layout.formRegion


    setTitleRegion: (deliverable) ->
      titleView = @getTitleView deliverable
      @show titleView,
        loading:
          loadingType: "spinner"
        region:  @layout.titleRegion
