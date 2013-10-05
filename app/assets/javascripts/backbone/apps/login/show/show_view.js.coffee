@Learnster.module "LoginApp.Show", (Show, App, Backbone, Marionette, $, _) ->

    class Show.Layout extends App.Views.Layout
        template: "login/show/templates/show_layout"

        regions:
            panelRegion: "#panel-region"
            formRegion: "#form-region"

    class Show.Panel extends App.Views.ItemView
        template: "login/show/templates/_panel"

    class Show.Form extends App.Views.ItemView
        template: "login/show/templates/_login_form"


