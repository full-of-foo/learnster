@Learnster.module "SessionApp.Create", (Create, App, Backbone, Marionette, $, _) ->

  class Create.Controller extends App.Controllers.Base

    initialize: ->
      @layout = @getLayoutView()

      @listenTo @layout, "show", ->
        @showPanel()
        @showForm()

      @show @layout

    showPanel: ->
      panelView = @getPanelView()
      @layout.panelRegion.show panelView

    showForm: (session) ->
      formView = @getFormView()
      @layout.formRegion.show formView

    getPanelView: ->
      new Create.Panel()

    getFormView: ->
      new Create.Form()

    getLayoutView: ->
      new Create.Layout()
