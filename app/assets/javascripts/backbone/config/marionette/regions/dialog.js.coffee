do ($, Backbone, Marionette) ->

  class Marionette.Region.Dialog extends Marionette.Region

    constructor: ->
      _.extend @, Backbone.Events

    onShow: (view) ->
      @setupBindings view
      @$el.on "hide.bs.modal", => @closeDialog()

    setupBindings: (view) ->
      @listenTo view, "hidden.bs.modal", @closeDialog
      $(window).on 'hashchange', @closeDialogAndBg

    closeDialog: =>
      @stopListening()
      @close()

    closeDialogAndBg: =>
      @$el.modal('hide')
      $('body').removeClass('modal-open');
      $('.modal-backdrop').remove();
