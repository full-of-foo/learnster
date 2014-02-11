@Learnster.module "LearningModulesApp.Assign", (Assign, App, Backbone, Marionette, $, _) ->

  class Assign.Layout extends App.Views.Layout
    template: "learning_modules/assign/templates/assign_layout"
    regions:
      formRegion: "#form-region"


  class Assign.Module extends App.Views.Layout
    template: "learning_modules/assign/templates/assign_module"
    regions:
      moduleSelectRegion: "#module-select-region"

    triggers:
      "click .cancel-assign-module" : "form:cancel"

    form:
      buttons:
        primary:    "Add Module"
        primaryClass: "btn btn-primary"
