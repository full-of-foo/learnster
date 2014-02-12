@Learnster.module "ModuleSupplementsApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends App.Views.Layout
    template: "module_supplements/show/templates/show_layout"
    regions:
      supplementRegion:              "#show-supplement-region"
      supplementContentsRegion:      "#supplement-contents-region"
      newSupplementContentRegion:    "#new-supplement-content-region"
      supplementContentsPanelRegion: "#supplement-contents-panel-region"


  class Show.Supplement extends App.Views.ItemView
    template: "module_supplements/show/templates/show_supplement"
    triggers:
      "click #edit-supplement-button" : "edit:supplement:button:clicked"
      "click #delete-supplement-button" : "delete:supplement:button:clicked"

  class Show.DeleteDialog extends App.Views.ItemView
    template: 'module_supplements/show/templates/delete_supplement_dialog'
    tagName: 'div'
    className: 'modal fade'
    triggers:
      "click #delete-supplement-button" : "dialog:delete:supplement:clicked"

    onShow: ->
      @$el.modal()


  class Show.DeleteContentDialog extends App.Views.ItemView
    template: 'module_supplements/show/templates/delete_content_dialog'
    tagName: 'div'
    className: 'modal fade'
    triggers:
      "click #delete-content-button" : "dialog:delete:supplement:content:clicked"

    onShow: ->
      @$el.modal()


  class Show.Panel extends App.Views.ItemView
    template: 'module_supplements/show/templates/panel'
    triggers:
      "click #new-supplement-content-button" : "new:supplement:content:button:clicked"
