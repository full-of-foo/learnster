@Learnster.module "SessionApp.Create", (Create, App, Backbone, Marionette, $, _) ->

    class Create.Layout extends App.Views.Layout
      template: "session/create/templates/create_layout"

      regions:
        panelRegion: "#panel-region"
        formRegion: "#form-region"

    class Create.Panel extends App.Views.ItemView
      template: "session/create/templates/_panel"

    class Create.Form extends App.Views.ItemView
      template: "session/create/templates/_sign_up_form"
      form:
        buttons:
          primary:      "Next"
          primaryClass: "btn btn-primary"
        toast: false
