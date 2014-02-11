@Learnster.module "LearningModulesApp.New", (New, App, Backbone, Marionette, $, _) ->

  class New.Layout extends App.Views.Layout
    template: "learning_modules/new/templates/new_layout"
    regions:
      formRegion: "#form-region"


  class New.Module extends App.Views.Layout
    template: "learning_modules/new/templates/new_module"
    regions:
      educatorSelectRegion: "#educator-select-region"

    triggers:
      "click .cancel-new-module" : "form:cancel"

    form:
      buttons:
        primary:    "Create Module"
        primaryClass: "btn btn-primary"
