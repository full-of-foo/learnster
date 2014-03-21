@Learnster.module "SessionApp.Create", (Create, App, Backbone, Marionette, $, _) ->

  class Create.Controller extends App.Controllers.Base

    initialize: (options = {}) ->
      @layout = @getLayoutView()

      @listenTo @layout, "show", ->
        @showPanel()
        if options.admin_id and options.code
          @showConfirmationFormFromMail(options.admin_id, options.code)
        else
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
        @showConfirmationForm(new_org_admin)

      @layout.currentFormRegion.show adminFormView

    showConfirmationFormFromMail: (id, code) ->
      validate_admin = App.reqres.request("validate_org_admin:entity", id, code)
      email_text = validate_admin.get('email')

      @listenTo validate_admin, "created", ->
        validate_admin.clear()
        auth_org_admin = App.request "new:auth:org_admin"
        @listenTo auth_org_admin, "created", ->
          @showOrgForm(auth_org_admin)
        confirmForm = @getConfirmationForm(auth_org_admin)
        confirmForm = App.request "form:wrapper", confirmForm
        @listenTo confirmForm, "show", ->
          _.delay((-> $('input#email').val(email_text)) , 400)
          @_completeCrumbItem("register-crumb")
          @_completeCrumbItem("intro-crumb")
          @_completeCrumbItem("admin-crumb")
        @layout.currentFormRegion.show confirmForm


    showConfirmationForm: (new_org_admin) ->
      email_text = new_org_admin.get('email')
      @showEmailSentDialog new_org_admin
      new_org_admin.clear()

      auth_org_admin = App.request "new:auth:org_admin"
      confirmForm = @getConfirmationForm(auth_org_admin)
      confirmForm = App.request "form:wrapper", confirmForm

      @listenTo confirmForm, "show", ->
        _.delay((-> $('input#email').val(email_text)) , 500)
        @_completeCrumbItem("register-crumb")


      @listenTo auth_org_admin, "created", ->
        @showOrgForm(auth_org_admin)

      @layout.currentFormRegion.show confirmForm

    showOrgForm: (org_admin) ->
      id = org_admin.get('id')
      code = org_admin.get('confirmation_code')
      new_org = App.reqres.request("new:signup:org:entity", id, code)
      orgFormView = @getOrgFormView(new_org)
      orgFormView = App.request "form:wrapper", orgFormView

      @listenTo orgFormView, "show", ->
        @_completeCrumbItem("org-crumb")

      @listenTo new_org, "created", ->
        _.delay(( => @showRegistrationCompleteDialog()), 650)
        App.navigate "/login"

      @show orgFormView,
        loading:
          loadingType: "spinner"
        region: @layout.currentFormRegion

    showAlreadyRegDialog: (admin) ->
      dialogView = @getAlreadyRegDialog admin
      @show dialogView,
          loading:
            loadingType: "spinner"
          region: App.dialogRegion

    showEmailSentDialog: (admin) ->
      dialogView = @getEmailSentDialog admin

      @show dialogView,
          loading:
            loadingType: "spinner"
          region: App.dialogRegion

    showRegistrationCompleteDialog: ->
      options =
        headerText: 'Registration Complete'
        contentText: 'Welcome aboard! Please sign in to get started...'
        primary: false
        secondary:
          text: 'Continue'
          cssClass: 'btn btn-success'
          hasDismiss: true

      App.request("show:dialog:box", options)


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

    getOrgFormView: (org_admin) ->
      new Create.OrgForm
        model: org_admin

    getAlreadyRegDialog: (admin) ->
      new Create.AlreadyRegisteredDialog
        model: admin

    getEmailSentDialog: (admin) ->
      new Create.EmailSentDialog
        model: admin

    getRegistrationCompleteDialog: (admin) ->
      new Create.RegistrationCompleteDialog
        model: admin

    getLayoutView: ->
      new Create.Layout()

    _completeCrumbItem: (elementId) ->
      $("##{elementId}").addClass('active')

