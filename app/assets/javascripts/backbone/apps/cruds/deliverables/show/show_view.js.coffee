@Learnster.module "DeliverablesApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends App.Views.Layout
    template: "deliverables/show/templates/show_layout"
    regions:
      deliverableRegion: "#show-deliverable-region"
      panelRegion:       "#panel-region"
      newRegion:         "#new-region"
      listRegion:        "#list-region"

  class Show.Deliverable extends App.Views.ItemView
    template: "deliverables/show/templates/show_deliverable"
    triggers:
      "click #edit-deliverable-button" : "edit:deliverable:button:clicked"
      "click #delete-deliverable-button" : "delete:deliverable:button:clicked"

  class Show.Panel extends App.Views.ItemView
    template: "deliverables/show/templates/panel"
    triggers:
      "click #new-submission-upload-button" : "new:upload:submission:button:clicked"
      "click #new-wiki-submission-button"   : "new:wiki:submission:button:clicked"

  class Show.DeleteDeliverableDialog extends App.Views.ItemView
    template: 'deliverables/show/templates/delete_deliverable_dialog'
    tagName: 'div'
    className: 'modal fade'
    triggers:
      "click #delete-deliverable-button" : "dialog:delete:deliverable:clicked"

    onShow: ->
      @$el.modal()
