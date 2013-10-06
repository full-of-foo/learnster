@Learnster.module "OrgsApp.New", (New, App, Backbone, Marionette, $, _) ->

        class New.Layout extends App.Views.Layout
            template: "organisations/new/templates/new_layout"
            regions: 
                formRegion:   "#form-region"

        class New.View extends App.Views.ItemView
            template: "organisations/new/templates/new_org"
            triggers:
                "click .cancel-new-org" : "form:cancel"
            form:
                buttons: 
                    primary:      "Add Organisation"
                    primaryClass: "btn btn-primary"