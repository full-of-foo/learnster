@Learnster.module "DeliverablesApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.Layout extends App.Views.Layout
    template: "deliverables/edit/templates/edit_layout"
    className: "container-fluid row-fluid"
    regions:
      titleRegion:  "#title-region"
      formRegion:   "#form-region"


  class Edit.Title extends App.Views.ItemView
    template: "deliverables/edit/templates/edit_title"
    modelEvents:
      "updated": "render"


  class Edit.Deliverable extends App.Views.ItemView
    template: "deliverables/edit/templates/edit_deliverable"
    modelEvents:
      "sync:after": "render"
    onShow: ->
      _.delay(( => $('.datepicker').datepicker({ format: 'dd/mm/yyyy'
              , autoclose: true })), 400)
    beforeClose: ->
      $('.datepicker').datepicker('remove')
