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
      new_org_admin = App.request "new:new_org_admin:entity"
      adminFormView = @getAdminFormView(new_org_admin)
      adminFormView = App.request "form:wrapper", adminFormView

      @listenTo adminFormView, "show", ->
        @_completeCrumbItem("admin-crumb")

      @listenTo new_org_admin, "created", ->
        @showConfirmationForm()

      @layout.currentFormRegion.show adminFormView

    showConfirmationForm: () ->
      confirm_org_admin = App.request "new:confirm_org_admin:entity"
      confirmForm = @getConfirmationForm(confirm_org_admin)
      confirmForm = App.request "form:wrapper", confirmForm

      @listenTo confirmForm, "show", ->
        @_completeCrumbItem("register-crumb")

      @layout.currentFormRegion.show confirmForm

    showOrgForm: () ->
      orgFormView = @getOrgFormView()
      @layout.currentFormRegion.show orgFormView


    # TODO - upload views

    getPanelView: ->
      new Create.Panel()

    getIntroView: ->
      new Create.Intro()

    getAdminFormView: (new_org_admin) ->
      new Create.AdminForm
        model: new_org_admin

    getConfirmationForm: (confirm_org_admin) ->
      new Create.ConfirmForm
        model: confirm_org_admin

    getOrgFormView: ->
      new Create.OrgForm()

    getLayoutView: ->
      new Create.Layout()

    _completeCrumbItem: (elementId) ->
      $("##{elementId}").addClass('active')

