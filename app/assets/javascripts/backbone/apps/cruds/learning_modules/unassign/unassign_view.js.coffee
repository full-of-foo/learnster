@Learnster.module "LearningModulesApp.Unassign", (Unassign, App, Backbone, Marionette, $, _) ->

  class Unassign.Layout extends App.Views.Layout
    template: "learning_modules/unassign/templates/unassign_layout"
    regions:
      formRegion: "#form-region"


  class Unassign.Module extends App.Views.Layout
    template: "learning_modules/unassign/templates/unassign_module"
    regions:
      moduleSelectRegion: "#module-select-region"

    triggers:
      "click .cancel-unassign-module" : "form:cancel"
      "click #remove-module-button"   : "remove:module:submitted"

    form:
      buttons:
        primary:    "Remove Module"
        primaryClass: "btn btn-primary"
