@Learnster.module "SessionApp.Create", (Create, App, Backbone, Marionette, $, _) ->

    class Create.Layout extends App.Views.Layout
      template: "session/create/templates/create_layout"

      regions:
        panelRegion: "#panel-region"
        currentFormRegion: "#current-form-region"

    class Create.Panel extends App.Views.ItemView
      template: "session/create/templates/_panel"

    class Create.Intro extends App.Views.ItemView
      template: "session/create/templates/_intro"
      triggers:
        "click li#intro-next-link" : "intro-link-clicked"

    class Create.AdminForm extends App.Views.ItemView
      template: "session/create/templates/_admin_form"
      form:
        buttons:
          primary: "Next"
          primaryClass: "btn btn-primary"
          cancel: false
        toast: false

    class Create.ConfirmForm extends App.Views.ItemView
      template: "session/create/templates/_confirm_form"
      form:
        buttons:
          primary: "Continue"
          cancel: false
          primaryClass: "btn btn-primary"
        toast: false

    class Create.OrgForm extends App.Views.ItemView
      template: "session/create/templates/_org_form"
      form:
        buttons:
          primary: "Complete Registration"
          cancel: false
          primaryClass: "btn btn-primary"
        toast: false

    class Create.AlreadyRegisteredDialog extends App.Views.ItemView
      template: 'session/create/templates/already_registered_dialog'
      tagName: 'div'
      className: 'modal fade'
      onShow: ->
        @$el.modal()

    class Create.EmailSentDialog extends App.Views.ItemView
      template: 'session/create/templates/email_sent_dialog'
      tagName: 'div'
      className: 'modal fade'
      onShow: ->
        @$el.modal()

    class Create.RegistrationCompleteDialog extends App.Views.ItemView
      template: 'session/create/templates/registration_complete_dialog'
      tagName: 'div'
      className: 'modal fade'
      onShow: ->
        @$el.modal()
