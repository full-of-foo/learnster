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
        toast: false

    class Create.OrgForm extends App.Views.ItemView
      template: "session/create/templates/_org_form"
      form:
        buttons:
          primary: "Next"
          primaryClass: "btn btn-primary"
        toast: false

    class Create.AdminUploadForm extends App.Views.ItemView
      template: "session/create/templates/_admin_upload_form"
      form:
        buttons:
          primary: "Next"
          primaryClass: "btn btn-primary"

    class Create.StudentUploadForm extends App.Views.ItemView
      template: "session/create/templates/_student_upload_form"
      form:
        buttons:
          primary: "Next"
          primaryClass: "btn btn-primary"
