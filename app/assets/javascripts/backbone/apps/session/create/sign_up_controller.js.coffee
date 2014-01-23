@Learnster.module "SessionApp.Create", (Create, App, Backbone, Marionette, $, _) ->

  class Create.Controller extends App.Controllers.Base

    initialize: ->
      @layout = @getLayoutView()

      @listenTo @layout, "show", ->
        @showPanel()
        @showIntro()

      @show @layout

    showPanel: ->
      panelView = @getPanelView()
      @layout.panelRegion.show panelView

    showIntro: () ->
      introView = @getIntroView()
      @listenTo introView, "show", ->
        @_completeCrumbItem("intro-crumb")
      @listenTo introView, "intro-link-clicked", ->
        @showAdminForm()

      @layout.currentFormRegion.show introView


    showAdminForm: () ->
      adminFormView = @getAdminFormView()
      @listenTo adminFormView, "show", ->
        @_completeCrumbItem("admin-crumb")

      @layout.currentFormRegion.show adminFormView

    showOrgForm: () ->
      orgFormView = @getOrgFormView()
      @layout.currentFormRegion.show orgFormView


    # TODO - upload views

    getPanelView: ->
      new Create.Panel()

    getIntroView: ->
      new Create.Intro()

    getAdminFormView: ->
      new Create.AdminForm()

    getOrgFormView: ->
      new Create.OrgForm()

    getLayoutView: ->
      new Create.Layout()

    _completeCrumbItem: (elementId) ->
      $("##{elementId}").addClass('active')

