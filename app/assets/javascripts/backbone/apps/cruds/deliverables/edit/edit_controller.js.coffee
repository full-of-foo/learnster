@Learnster.module "DeliverablesApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.Controller extends App.Controllers.Base

    initialize: (options) ->
      id = options.id
      deliverable = App.request "deliverable:entity", id

      App.execute "when:fetched", deliverable, =>
        @listenTo deliverable, "updated", ->
          App.request "show:deliverable", deliverable

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
        App.request "show:deliverable", deliverable

      formView = App.request "form:wrapper", editView,
        toast:
          message: "#{deliverable.get('title')} updated"

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
