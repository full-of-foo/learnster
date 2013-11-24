@Learnster.module "StudentsApp.Import", (Import, App, Backbone, Marionette, $, _) ->

  class Import.Dialog extends App.Views.ItemView
    template: 'students/import/templates/import_dialog'
    tagName: 'div'
    className: 'modal fade'

    onShow: ->
      @$el.modal()