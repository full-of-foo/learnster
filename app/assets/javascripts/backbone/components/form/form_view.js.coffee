@Learnster.module "Components.Form", (Form, App, Backbone, Marionette, $, _) ->

  class Form.FormWrapper extends App.Views.Layout
    template: "form/form"
    className: "form-horizontal"
    tagName: "form"
    attributes: ->
      "data-type": @getFormDataType()

    regions:
      formContentRegion: "#form-content-region"

    ui:
      buttonContainer: "div#form-btn-wrapper"

    triggers:
      "submit"                            : "form:submit"
      "click [data-form-button='cancel']" : "form:cancel"

    modelEvents:
      "change:_errors" : "changeErrors"
      "sync:start"     : "syncStart"
      "sync:stop"      : "syncStop"

    initialize: ->
      @setInstancePropertiesFor "config", "buttons"

    serializeData: ->
      footer: @config.footer
      buttons: @buttons?.toJSON() ? false

    onShow: ->
      _.defer =>
        @focusFirstInput()    if @config.focusFirstInput
        @addButtonPlacement() if @button
        @addToolTips()

    onClose: ->
      @addOpacityWrapper(false)

    addButtonPlacement: ->
      $("div#form-btn-wrapper").addClass @buttons.placement

    addInputToolTip: ($input) ->
      @_addToolTipTitle($input, 'First name of account holder')   if $input.attr('id') is 'first_name'
      @_addToolTipTitle($input, 'Surname of account holder')      if $input.attr('id') is 'surname'
      @_addToolTipTitle($input, 'Valid email of account holder')  if $input.attr('id') is 'email'
      @_addToolTipTitle($input, 'Account holder password')        if $input.attr('id') is 'password'
      @_addToolTipTitle($input, 'Must match password')            if $input.attr('id') is 'password_confirmation'
      @_addToolTipTitle($input, 'Indentifier/reference-number (ex. Eng101)') if $input.attr('id') is 'identifier'
      @_addToolTipTitle($input, @_getTitleForTitleAttr())         if $input.attr('id') is 'title'
      @_addToolTipTitle($input, @_getTitleForDescriptionAttr())   if $input.attr('id') is 'description'
      @_addToolTipTitle($input, 'Breif notes on your submission')             if $input.attr('id') is 'notes'
      @_addToolTipTitle($input, 'main title for section (ex. Semester 1)')      if $input.attr('id') is 'section'
      @_addToolTipTitle($input, 'hides students submissions from each other')   if $input.attr('id') is 'is_private'
      @_addToolTipTitle($input, 'do not allow any further student submissions') if $input.attr('id') is 'is_closed'
      @_addToolTipTitle($input, 'due date can be changed later') if $input.attr('id') is 'due_date'

    addSelectToolTip: ($select) ->
      _.delay(( =>
        if @$('select').attr('id') is 'formatted_role'
          @_addToolTipTitle($select, 'Role cannot be changed later')
        else if @$('select').attr('id') is 'provisioned_by'
          @_addToolTipTitle($select, 'Provisioning admin/educator for section')
        else if @$('select').attr('id') is 'educator'
          @_addToolTipTitle($select, 'Primary educator managing the module')

        ), 2000)

    _addToolTipTitle: ($elem, title) ->
      $elem.tooltip({placement: 'right', title: title, trigger: 'hover focus'})

    _getTitleForTitleAttr: ->
      return 'Main course title (ex. MA in Poetry Studies)' if @model instanceof App.Entities.Course
      return 'title for learning module (ex. Advanced English Studies)' if @model instanceof App.Entities.LearningModule
      return 'title for lesson/supplement (ex. Lecture 1)' if @model instanceof App.Entities.ModuleSupplement
      return 'title for upload (ex. Lecture Slides)'       if @model instanceof App.Entities.ContentUpload
      return 'title for wiki (ex. Module Descriptor Wiki)' if @model instanceof App.Entities.WikiContent
      return 'title for deliverable (ex. Assignment 1)'    if @model instanceof App.Entities.Deliverable

    _getTitleForDescriptionAttr: ->
      return 'Breif description of the course' if @model instanceof App.Entities.Course
      return 'Breif description of the module' if @model instanceof App.Entities.LearningModule
      return 'Breif description of lesson/supplement' if @model instanceof App.Entities.ModuleSupplement
      return 'Breif description of upload' if @model instanceof App.Entities.ContentUpload
      return 'Breif description of wiki' if @model instanceof App.Entities.WikiContent
      return 'Breif description of deliverable' if @model instanceof App.Entities.Deliverable

    addError: (name, error) ->
      el = @$("[id='#{name}']")
      el = el.parent() if el.parent().hasClass("input-prepend")
      sm = $("<small>").text(error).addClass("help-inline")
      el.after(sm).closest(".control-group").addClass("error")

    focusFirstInput: ->
      @$(":input[type='text']:visible:enabled:first").focus()

    getFormDataType: ->
      user = App.request "get:current:user"
      isNew = @model.isNew()
      if Object(user) not instanceof Boolean
        createdByUser = if !isNew then (@model
          .get('created_by')?.id is user?.get('id') or user instanceof App.Entities.AppAdmin) else false
      else
        createdByUser = false

      if @model.isNew()
        "new"
      else if not createdByUser
        "show"
      else
        "edit"

    changeErrors: (model, errors, options) ->
      if @config.errors
        if _.isEmpty(errors) then @removeErrors() else @addErrors errors

    removeErrors: ->
      @$(".error").removeClass("error").find("small").remove()

    addErrors: (errors = {}) ->
      for name, array of errors
        @addError(name, array[0])

    addToolTips: ->
      for $input in @$('input')
        @addInputToolTip($($input))
      for $select in @$('.bootstrap-select')
        @addSelectToolTip($($select))

    syncStart: (model) ->
      @addOpacityWrapper() if @config.syncing

    syncStop: (model) ->
      @addOpacityWrapper(false) if @config.syncing
