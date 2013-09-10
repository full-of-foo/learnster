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

		initialize: ->	
			@setInstancePropertiesFor "config", "buttons"

		serializeData: ->
			footer: @config.footer
			buttons: @buttons?.toJSON() ? false

		onShow: ->
			_.defer =>
				@focusFirstInput() if @config.focusFirstInput
				@buttonPlacement() if @buttons

		buttonPlacement: ->
			@ui.buttonContainer.addClass @buttons.placement

		addError: (name, error) ->
	   		el = @$("[id='#{name}']")
	   		sm = $("<small>").text(error).addClass("help-inline")
	   		el.after(sm).closest(".control-group").addClass("error")

		focusFirstInput: -> 
			@$(":input:visible:enabled:first").focus()

		getFormDataType: ->
			if @model.isNew() then "new" else "edit"

		changeErrors: (model, errors, options) ->
			if @config.errors
				if _.isEmpty(errors) then @removeErrors() else @addErrors errors

		removeErrors: ->
			@$(".error").removeClass("error").find("small").remove()

		addErrors: (errors = {}) ->
			for name, array of errors
				@addError(name, array[0])
