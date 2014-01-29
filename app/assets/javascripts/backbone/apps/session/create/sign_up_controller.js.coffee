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
      admin = App.reqres.request("validate_org_admin:entity", id, code)
      confirmForm = @getConfirmationForm(admin)
      confirmForm = App.request "form:wrapper", confirmForm

      @listenTo admin, "created", ->
        @layout.currentFormRegion.show confirmForm

      @listenTo confirmForm, "show", ->
        _.delay((-> $('input#email').val(admin.get('email'))) , 400)
        @_completeCrumbItem("register-crumb")
        @_completeCrumbItem("intro-crumb")
        @_completeCrumbItem("admin-crumb")
        is_confirmed = admin.get('confirmed')
        has_org = admin.get('admin_for')
        if is_confirmed and not has_org
          console.log('confirmed')
          console.log admin
        else if is_confirmed and has_org
          @showAlreadyRegDialog(admin)

      App.execute "show:loading", @layout.currentFormRegion.currentView,
        loading:
              loadingType: "spinner"
        region:  @layout.currentFormRegion




    showConfirmationForm: (new_org_admin) ->
      confirmForm = @getConfirmationForm(new_org_admin)
      confirmForm = App.request "form:wrapper", confirmForm

      @listenTo confirmForm, "show", ->
        _.delay((-> $('input#email').val(new_org_admin.get('email'))) , 500)
        @_completeCrumbItem("register-crumb")
        @showEmailSentDialog new_org_admin

      @layout.currentFormRegion.show confirmForm

    showOrgForm: () ->
      orgFormView = @getOrgFormView()
      @layout.currentFormRegion.show orgFormView

    showAlreadyRegDialog: (admin) ->
      dialogView = @getAlreadyRegDialog admin
      @listenTo dialogView, "todo:close:event", =>
        dialogView.$el.modal "hide"

      @show dialogView,
          loading:
            loadingType: "spinner"
          region: App.dialogRegion

    showEmailSentDialog: (admin) ->
      dialogView = @getEmailSentDialog admin
      @listenTo dialogView, "todo:close:event", =>
        dialogView.$el.modal "hide"

      @show dialogView,
          loading:
            loadingType: "spinner"
          region: App.dialogRegion

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

    getAlreadyRegDialog: (admin) ->
      new Create.AlreadyRegisteredDialog
        model: admin

    getEmailSentDialog: (admin) ->
      new Create.EmailSentDialog
        model: admin

    getLayoutView: ->
      new Create.Layout()

    _completeCrumbItem: (elementId) ->
      $("##{elementId}").addClass('active')

