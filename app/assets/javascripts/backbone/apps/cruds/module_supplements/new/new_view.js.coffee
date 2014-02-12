@Learnster.module "ModuleSupplementsApp.New", (New, App, Backbone, Marionette, $, _) ->

  class New.Layout extends App.Views.Layout
    template: "module_supplements/new/templates/new_layout"
    regions:
      formRegion: "#form-region"


  class New.View extends App.Views.ItemView
    template: "module_supplements/new/templates/new_supplement"
    triggers:
      "click .cancel-new-supplement" : "form:cancel"

    form:
      buttons:
        primary:    "Create Supplement"
        primaryClass: "btn btn-primary"
