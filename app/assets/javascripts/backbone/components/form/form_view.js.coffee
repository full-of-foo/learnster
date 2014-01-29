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
			"submit"						    : "form:submit"
			"click [data-form-button='cancel']" : "form:cancel"

		modelEvents:
			"change:_errors" : "changeErrors"
			"sync:start" 	 : "syncStart"
			"sync:stop" 	 : "syncStop"

		initialize: ->
			@setInstancePropertiesFor "config", "buttons"

		serializeData: ->
			footer: @config.footer
			buttons: @buttons?.toJSON() ? false

		onShow: ->
			_.defer =>
				@focusFirstInput()    if @config.focusFirstInput
				@addButtonPlacement() if @button

		onClose: ->
			@addOpacityWrapper(false)

		addButtonPlacement: ->
			$("div#form-btn-wrapper").addClass @buttons.placement

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

		syncStart: (model) ->
			@addOpacityWrapper() if @config.syncing

		syncStop: (model) ->
			@addOpacityWrapper(false) if @config.syncing
