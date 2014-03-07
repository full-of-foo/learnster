@Learnster.module "Components.Form", (Form, App, Backbone, Marionette, $, _) ->

  class Form.Controller extends App.Controllers.Base

    initialize: (options = {}) ->
      @contentView = options.view
      @formLayout = @getFormLayout options.config

      @listenTo @formLayout, "show", @setFormContentRegion
      @listenTo @formLayout, "form:submit", @formSubmit
      @listenTo @formLayout, "form:cancel", @formCancel

    formCancel: ->
      @contentView.triggerMethod "form:cancel"

    formSubmit: ->
      model = @contentView.model
      console.debug model
      if model.beforeSave
        console.debug model.beforeSave
        model.beforeSave(model)
        _.delay((=> @submit()), 450)
      else
        @submit()

    submit: ->
      data = Backbone.Syphon.serialize @formLayout
      if @contentView.triggerMethod("form:submit", data) isnt false
        model = @contentView.model
        collection = @contentView.collection
        @processFormSubmit data, model, collection, @formLayout.config.toast


    processFormSubmit: (data, model, collection, toast = false) ->
      model.save data,
        collection: collection
        toast: toast

    setFormContentRegion: ->
      @region = @formLayout.formContentRegion
      @show @contentView


    getFormLayout: (options = {}) ->
      config = @getDefaultConfig _.result(@contentView, "form")
      _.extend config, options

      buttons = @getButtons config.buttons

      new Form.FormWrapper
        config: config
        model: @contentView.model
        buttons: buttons


    getDefaultConfig: (config = {}) ->
      _.defaults config,
        footer: true
        focusFirstInput: true
        errors: true
        syncing: true
        toast: true


    getButtons: (buttons = {}) ->
      App.request("form:button:entities", buttons, @contentView.model) unless buttons is false



  App.reqres.setHandler "form:wrapper", (contentView, options = {}) ->
    throw new Error "No model found inside of form's contentView" unless contentView.model
    formController = new Form.Controller
      view: contentView
      config: options
    formController.formLayout

