@Learnster.module "SessionApp.Show", (Show, App, Backbone, Marionette, $, _) ->

    class Show.Layout extends App.Views.Layout
        template: "session/show/templates/show_layout"

        regions:
            panelRegion: "#panel-region"
            formRegion: "#form-region"

    class Show.Panel extends App.Views.ItemView
        template: "session/show/templates/_panel"

    class Show.Form extends App.Views.ItemView
        template: "session/show/templates/_login_form"
        form:
            buttons:
                primary:      "Login"
                primaryClass: "btn btn-primary"
            toast: false


