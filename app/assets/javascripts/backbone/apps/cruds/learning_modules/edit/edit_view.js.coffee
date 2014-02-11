@Learnster.module "LearningModulesApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.Layout extends App.Views.Layout
    template: "learning_modules/edit/templates/edit_layout"
    regions:
      titleRegion:  "#title-region"
      formRegion:   "#form-region"


  class Edit.Title extends App.Views.ItemView
    template: "learning_modules/edit/templates/edit_title"
    modelEvents:
      "updated": "render"


  class Edit.Module extends App.Views.Layout
    template: "learning_modules/edit/templates/edit_module"
    regions:
      educatorSelectRegion: "#educator-select-region"
    modelEvents:
      "sync:after": "render"
