@Learnster.module "Components.DialogBox", (DialogBox, App, Backbone, Marionette, $, _) ->

  class DialogBox.Dialog extends App.Views.ItemView
    template: 'dialog_box/templates/dialog_box'
    tagName: 'div'
    className: 'modal fade'
    triggers:
      "click #primary-button"   : "dialog:primary:clicked"
      "click #secondary-button" : "dialog:secondary:clicked"

    onShow: ->
      @$el.modal()

