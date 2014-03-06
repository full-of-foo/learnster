@Learnster.module "DeliverablesApp.New", (New, App, Backbone, Marionette, $, _) ->

  class New.Layout extends App.Views.Layout
    template: "deliverables/new/templates/new_layout"
    regions:
      formRegion: "#form-region"

  class New.Deliverable extends App.Views.Layout
    template: "deliverables/new/templates/new_deliverable"
    triggers:
      "click .cancel-new-deliverable" : "form:cancel"
    onShow: ->
      _.delay(( => $('.datepicker').datepicker({ format: 'dd/mm/yyyy'
              , autoclose: true })), 400)
    beforeClose: ->
      $('.datepicker').datepicker('remove')




