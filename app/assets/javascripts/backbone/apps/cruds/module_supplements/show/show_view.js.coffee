@Learnster.module "ModuleSupplementsApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends App.Views.Layout
    template: "module_supplements/show/templates/show_layout"
    regions:
      supplementRegion: "#show-supplement-region"
      listRegion:       "#list-region"
      newRegion:        "#new-region"
      panelRegion:      "#panel-region"
    triggers:
      "click #contents-tab"     : "contents:tab:clicked"
      "click #deliverables-tab" : "deliverables:tab:clicked"


  class Show.Supplement extends App.Views.ItemView
    template: "module_supplements/show/templates/show_supplement"
    triggers:
      "click #edit-supplement-button" : "edit:supplement:button:clicked"
      "click #delete-supplement-button" : "delete:supplement:button:clicked"
      "click #cancel-show-supplement" : "cancel:show:supplement:button:clicked"

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

  class Show.DeleteDeliverableDialog extends App.Views.ItemView
    template: 'module_supplements/show/templates/delete_deliverable_dialog'
    tagName: 'div'
    className: 'modal fade'
    triggers:
      "click #delete-deliverable-button" : "dialog:delete:deliverable:clicked"

    onShow: ->
      @$el.modal()

  class Show.Panel extends App.Views.ItemView
    template: 'module_supplements/show/templates/panel'
    triggers:
      "click #new-content-upload-button" : "new:upload:content:button:clicked"
      "click #new-wiki-content-button"   : "new:wiki:content:button:clicked"

  class Show.DeliverablePanel extends App.Views.ItemView
    template: 'module_supplements/show/templates/deliverable_panel'
    triggers:
      "click #new-deliverable-button" : "new:deliverable:button:clicked"

