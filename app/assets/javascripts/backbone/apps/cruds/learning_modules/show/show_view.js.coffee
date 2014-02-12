@Learnster.module "LearningModulesApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends App.Views.Layout
    template: "learning_modules/show/templates/show_layout"
    regions:
      moduleRegion: "#module-region"
      panelRegion: "#module-supplement-panel-region"
      supplementsRegion: "#list-module-supplement-region"

  class Show.Module extends App.Views.ItemView
    template: "learning_modules/show/templates/show_module"
    triggers:
      "click #edit-module-button"   : "edit:module:button:clicked"
      "click #delete-module-button" : "delete:module:button:clicked"

  class Show.DeleteDialog extends App.Views.ItemView
    template: 'learning_modules/show/templates/delete_dialog'
    tagName: 'div'
    className: 'modal fade'
    triggers:
      "click #delete-module-button" : "dialog:delete:module:clicked"

    onShow: ->
      @$el.modal()


  class Show.Panel extends App.Views.ItemView
    template: 'learning_modules/show/templates/panel'
    triggers:
      "click #add-module-supplement-button"    : "add:module:supplement:button:clicked"
